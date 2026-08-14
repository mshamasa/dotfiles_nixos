{ config, pkgs, ... }:

{

programs.rofi = {
  enable = true;
  terminal = "wezterm"; # or your terminal of choice
  font = "Mononoki Nerd Font";
  theme = "gruvbox-dark-soft";
  extraConfig = {
    lines = 10;
    width = 50;
    padding = 15;
    columns = 1;
    case-sensitive = false;
    cycle = true;
    matching = "fuzzy";
    click-to-exit = true;
    show-icons = true;
    icon-theme = "Papirus-Dark";
  };
};
}
