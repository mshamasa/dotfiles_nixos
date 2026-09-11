{ pkgs, ... }:

# Temporary diagnostic for the intermittent MT7925 (AMD RZ717) failure where the
# PCIe device enumerates but the mt7925e driver never binds, so no wireless
# interface exists and nmtui has nothing to work with.
#
# On the failed boots of 2026-09-10 the kernel logged the PCI device but zero
# mt7925e lines -- no probe error at all. That is ambiguous between "the module
# never loaded" and "probe failed silently", and those have different fixes.
# This unit captures the state at failure time to settle it, then tries the
# recovery steps in increasing severity and records which one worked.
#
# Reports land in /var/log/wifi-diag/. Read the latest with: wifi-diag
# Delete this file and its import once the cause is known.

{
  systemd.services.wifi-diag = {
    description = "Capture MT7925 diagnostics when no wireless interface appears at boot";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "NetworkManager.service"
    ];

    path = with pkgs; [
      kmod
      pciutils
      util-linux
      iproute2
      coreutils
      gnugrep
      gawk
    ];
    serviceConfig = {
      Type = "oneshot";
      LogsDirectory = "wifi-diag";
    };

    script = ''
      set -u

      LOGDIR=/var/log/wifi-diag
      STAMP=$(date +%Y%m%d-%H%M%S)
      REPORT=$LOGDIR/$STAMP.log
      WIFI_PCI_ID=14c3:0717

      # Any interface with a wireless/ sysfs dir means the driver bound.
      find_iface() {
        for w in /sys/class/net/*/wireless; do
          if [ -e "$w" ]; then
            basename "$(dirname "$w")"
            return 0
          fi
        done
        return 1
      }

      # Give udev coldplug and module autoload a generous window before
      # declaring failure, so a slow boot is not logged as a false positive.
      IFACE=""
      for _ in $(seq 1 45); do
        if IFACE=$(find_iface); then break; fi
        sleep 1
      done

      if [ -n "$IFACE" ]; then
        echo "wifi-diag: OK, wireless interface $IFACE present"
        exit 0
      fi

      PCI_ADDR=$(lspci -Dn 2>/dev/null | awk -v id="$WIFI_PCI_ID" '$3==id {print $1}' | head -1)
      [ -n "$PCI_ADDR" ] || PCI_ADDR=0000:c0:00.0

      echo "wifi-diag: NO wireless interface after 45s -- writing $REPORT"

      {
        echo "=============================================================="
        echo "MT7925 wifi failure report"
        echo "date        : $(date -Is)"
        echo "kernel      : $(uname -r)"
        echo "bios        : $(cat /sys/class/dmi/id/bios_version 2>/dev/null) ($(cat /sys/class/dmi/id/bios_date 2>/dev/null))"
        echo "board       : $(cat /sys/class/dmi/id/product_name 2>/dev/null)"
        echo "pci address : $PCI_ADDR"
        echo "=============================================================="
        echo

        echo "### THE DISCRIMINATOR: is mt7925e loaded? ###"
        if lsmod | grep -q '^mt7925e'; then
          echo "VERDICT: module IS loaded -> it loaded but probe failed."
          echo "         ASPM/link-level theory lives; disable_aspm=1 is the right lever."
        else
          echo "VERDICT: module is NOT loaded -> autoload never happened."
          echo "         disable_aspm=1 is irrelevant here; force it in with"
          echo '         boot.kernelModules = [ "mt7925e" ];'
        fi
        echo

        echo "### loaded mt76 stack ###"
        lsmod | grep -E 'mt7925|mt792x|mt76|mac80211|cfg80211' || echo "(none loaded)"
        echo

        echo "### pci device ###"
        lspci -nnk -s "$PCI_ADDR" 2>/dev/null || echo "(device not in lspci)"
        echo "driver bound: $(basename "$(readlink -f /sys/bus/pci/devices/$PCI_ADDR/driver 2>/dev/null)" 2>/dev/null || echo NONE)"
        echo "power state : $(cat /sys/bus/pci/devices/$PCI_ADDR/power_state 2>/dev/null || echo unknown)"
        echo "enabled     : $(cat /sys/bus/pci/devices/$PCI_ADDR/enable 2>/dev/null || echo unknown)"
        echo

        echo "### disable_aspm setting ###"
        cat /sys/module/mt7925e/parameters/disable_aspm 2>/dev/null || echo "(module not loaded)"
        echo

        echo "### rfkill ###"
        rfkill list 2>/dev/null || echo "(rfkill unavailable)"
        echo

        echo "### network interfaces ###"
        ip -br link 2>/dev/null
        echo

        echo "### dmesg: mt7925 / pci / firmware ###"
        dmesg 2>/dev/null | grep -iE "mt7925|mt792x|$PCI_ADDR|firmware|r8169" || echo "(no matching lines -- itself significant)"
        echo
      } > "$REPORT" 2>&1

      # --- staged recovery, least invasive first -------------------------
      # Each stage records whether it restored the interface, which tells us
      # how deep the reset has to go.
      {
        echo "### RECOVERY ATTEMPTS ###"

        if ! lsmod | grep -q '^mt7925e'; then
          echo "-- stage A: modprobe mt7925e (module was absent)"
          modprobe mt7925e 2>&1 || echo "   modprobe failed with status $?"
        else
          echo "-- stage A: skipped (module already loaded)"
        fi
        sleep 5
        if IFACE=$(find_iface); then
          echo "RESULT: recovered at stage A (plain module load) -- interface $IFACE"
          echo "meaning: module autoload race, not a hardware fault."
          exit 0
        fi

        echo "-- stage B: modprobe -r mt7925e then modprobe mt7925e"
        modprobe -r mt7925e 2>&1 || echo "   unload failed with status $?"
        sleep 2
        modprobe mt7925e 2>&1 || echo "   reload failed with status $?"
        sleep 5
        if IFACE=$(find_iface); then
          echo "RESULT: recovered at stage B (driver reload) -- interface $IFACE"
          echo "meaning: software-level probe failure; chip itself was fine."
          exit 0
        fi

        echo "-- stage C: PCI remove + rescan (hardware-level re-enumeration)"
        echo 1 > /sys/bus/pci/devices/$PCI_ADDR/remove 2>&1 || echo "   remove failed"
        sleep 2
        echo 1 > /sys/bus/pci/rescan 2>&1 || echo "   rescan failed"
        sleep 8
        if IFACE=$(find_iface); then
          echo "RESULT: recovered at stage C (PCI re-enumeration) -- interface $IFACE"
          echo "meaning: the PCIe link needed a real reset. Points at firmware/BIOS,"
          echo "         and makes the BIOS 3.06 update the next thing worth trying."
          exit 0
        fi

        echo "RESULT: all stages failed -- a reboot is genuinely required."
        echo "meaning: the chip is wedged below the level Linux can reset."
      } >> "$REPORT" 2>&1

      exit 0
    '';
  };

  # Convenience reader for the newest report.
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "wifi-diag" ''
      LOGDIR=/var/log/wifi-diag
      if [ ! -d "$LOGDIR" ] || [ -z "$(ls -A $LOGDIR 2>/dev/null)" ]; then
        echo "No wifi failures recorded yet -- every boot since install has been clean."
        echo "(Reports appear in $LOGDIR only when no wireless interface shows up.)"
        exit 0
      fi
      LATEST=$(ls -1t $LOGDIR/*.log 2>/dev/null | head -1)
      echo "Failure reports on record: $(ls -1 $LOGDIR/*.log 2>/dev/null | wc -l)"
      echo "Showing newest: $LATEST"
      echo
      cat "$LATEST"
    '')
  ];
}
