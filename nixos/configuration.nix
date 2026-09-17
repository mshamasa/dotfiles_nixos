{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./wifi-diagnostics.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    efi.efiSysMountPoint = "/boot";
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 10;
  };

  # this might help with wifi chip not loading on boot, not sure
  # we can also try restarting the drivers with
  # sudo modprobe -r mt7925e && sudo modprobe mt7925e
  # -r meas remove/unmount and then calling it again means mount it again
  boot.extraModprobeConfig = ''
    options mt7925e disable_aspm=1
  '';

  # removes stale builds on a weekly basis
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nixpkgs.config.allowUnfree = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  networking = {
    hostName = "ms"; # Define your hostname.
    # Configure network connections interactively with nmcli or nmtui.
    networkmanager.enable = true;

    firewall = {
      allowedTCPPorts = [
        8080
        8081
        8082
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # services.displayManager.ly.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd mango";
        user = "greeter";
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ms = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
    ]; # Enable ‘sudo’ for the user.
    # packages = with pkgs; [
    #   tree
    # ];
  };

  programs.mango.enable = true;
  programs.fish.enable = true;
  # needed for expo dev work
  programs.nix-ld.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    git
    wezterm
    greetd
    tuigreet
    bluetui
    vivaldi
    # nix lsp and formatter
    # it's needed here at the root for it work on these files
    nil
    nixfmt
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.mononoki
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.activationScripts.rootNvimConfig.text = ''
    mkdir -p /root/.config /root/.local/share
    ln -sfn /home/ms/.config/nvim /root/.config/nvim
    ln -sfn /home/ms/.local/share/nvim /root/.local/share/nvim
  '';

  system.stateVersion = "26.05";

}
