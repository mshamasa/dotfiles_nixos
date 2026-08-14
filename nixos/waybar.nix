{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        exclusive = true;
        height = 36;
        spacing = 10;

        "modules-left" = [
          "ext/workspaces"
        ];

        "modules-center" = [
        ];

        "modules-right" = [
          "network"
          "battery"
          "wireplumber"
          "clock"
        ];

        "ext/workspaces" = {
          format = "{name}";
	  sort-by-id = true;
	  ignore-hidden = true;
	  "on-click" = "activate";
	  "on-click-right" = "deactivate";
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M %Z}";
          tooltip-format = "{:%A, %B %d, %Y}";
          timezones = [ "America/Los_Angeles" ];
          interval = 60;
        };

        battery = {
          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-icons = ["󰁺" "󰁻" "󰁽" "󰂀" "󰁹"];
          interval = 60;
        };

        wireplumber = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 {volume}%";
          format-icons.default = ["󰕿" "󰖀" "󰕾"];
          scroll-step = 1;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
        };

        # "mango/window" = {
        #   format = "{title}";
        #   max-length = 60;
        #   rewrite = {
        #     "(.*) - Mozilla Firefox" = "🌎 $1";
        #     "(.*) - (.*)" = "$1";
        #   };
        # };

        network = {
          format= "{ifname}";
          format-wifi = "󰤨  {essid} ({signalStrength}%)";
          format-ethernet = "󰈀  {ifname}";
          format-disconnected = "󰤭  Disconnected";
          tooltip-format= "{ifname}";
          tooltip-format-wifi= "{essid} ({signalStrength}%) ";
          tooltip-format-ethernet= "{ifname} ";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
        };
      };
    };

    style = ''
      * {
        font-family: "Mononoki Nerd Font";
        font-size: 18px;
        border: none;
      }

      window#waybar {
        background: transparent;
        color: #ccc;
      }

      /* enable once mango/window is in latest release
      #window {
        color: #aaa;
        padding-left: 8px;
        font-style: italic;
      }
      */

      #workspaces {
        background: rgba(30, 30, 30, 0.9);
        border-radius: 8px;
        padding: 2px;
      }

      #workspaces button {
        color: #888;
        padding: 2px 4px;
        border-radius: 4px;
      }

      #workspaces button.active {
        background: #5a7dbf;
        color: #fff;
      }

      #workspaces button.visible {
        color: #ccc;
      }

      #workspaces button.hidden {
        color: #666;
      }

      #workspaces button.urgent {
        background: #ff6b6b;
        color: #fff;
      }

      #clock {
        background: rgba(30, 30, 30, 0.9);
        border-radius: 8px;
        padding: 0 10px;
      }

      #battery {
        background: rgba(30, 30, 30, 0.9);
        border-radius: 8px;
        padding: 0 8px;
      }

      #network {
        background: rgba(30, 30, 30, 0.9);
        border-radius: 8px;
        padding: 0 8px;
      }

      #battery.warning {
        color: #ffb347;
      }

      #battery.critical {
        color: #ff6b6b;
      }

      #wireplumber {
        background: rgba(30, 30, 30, 0.9);
        border-radius: 8px;
        padding: 0 8px;
      }

      #wireplumber.muted {
        color: #888;
      }
    '';
  };

  home.packages = with pkgs; [
    # mango automatically pulls in PipeWire so we use that for audio
    wireplumber
  ];
}
