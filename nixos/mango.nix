{
  wayland.windowManager.mango = {
    enable = true;

    settings = {
      # Tearing for games
      allow_tearing = 1;

      border_radius = 6;

      monitorrule = [
        # laptop at the bottom
        "name:eDP-1,scale:1,x:384,y:2160"
        # Dell on top
        "name:DP-6,scale:1,x:0,y:0"
      ];

      # shows all workspaces
      tagrule = map (id: "id:${toString id},no_hide:1") (builtins.genList (i: i + 1) 9);

      bind = [
        # rofi
        "SUPER,Space,spawn,rofi -show drun"

        # workspaces
        "SUPER,1,view,1,0"
        "SUPER,2,view,2,0"
        "SUPER,3,view,3,0"
        "SUPER,4,view,4,0"
        "SUPER,5,view,5,0"
        "SUPER,6,view,6,0"
        "SUPER,7,view,7,0"
        "SUPER,8,view,8,0"
        "SUPER,9,view,9,0"

        # Vim-style window navigation with Super key
        "SUPER,h,focusdir,left"
        "SUPER,j,focusdir,down"
        "SUPER,k,focusdir,up"
        "SUPER,l,focusdir,right"

        # screen shots
        ''SUPER,p,spawn_shell,grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png''
        # copy directly to clipboard
        ''SUPER+SHIFT,p,spawn_shell,grim -g "$(slurp)" - | wl-copy''

        "SUPER,q,killclient"
        "SUPER,Return,spawn,wezterm"

        "SUPER,r,reload_config"
      ];
    };

    # Written to ~/.config/mango/autostart.sh; the module adds the exec-once line.
    autostart_sh = ''
      waybar >/dev/null 2>&1 &
      swaybg -i ${./walls/chaos.png} -m fill &
    '';
  };
}
