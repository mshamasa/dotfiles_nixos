{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };


  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    efi.efiSysMountPoint = "/boot";
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 10;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "ms"; # Define your hostname.
  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd mango";
	user = "greeter";
      };
    };
  };

  # Configure lid switch behavior (laptops)
  # services.logind.settings.Login = {
  #   HandleLidSwitch = "suspend";
  # };
  # services.logind.lidSwitchDocked = "ignore";
  # services.logind.lidSwitchExternalPower = "lock";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ms = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.mango.enable = true;
  programs.zsh.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    git
    wezterm
    greetd
    tuigreet
    python3
    # bluetooth tui
    bluetui
    brave
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.mononoki
  ];


  system.stateVersion = "26.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}

