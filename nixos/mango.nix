{
  wayland.windowManager.mango = {
    enable = true;

    settings = {
      # Tearing for games
      allow_tearing = 1;

      border_radius = 6;

      monitor_rule = [
        # laptop at the bottom
        "name:eDP-1,scale:1,x:384,y:2160"
        # Dell on top
        "name:DP-6,scale:1,x:0,y:0"
      ];

      # shows all workspaces
      tag_rule = map (id: "id:${toString id},no_hide:1") (builtins.genList (i: i + 1) 9);

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

        # Swap window with its neighbour (Super+Shift + vim keys)
        "SUPER+SHIFT,h,exchange_client,left"
        "SUPER+SHIFT,j,exchange_client,down"
        "SUPER+SHIFT,k,exchange_client,up"
        "SUPER+SHIFT,l,exchange_client,right"

        # Move window to the other monitor (Dell is above the laptop)
        "SUPER+ALT,k,tagmon,up"
        "SUPER+ALT,j,tagmon,down"

        "SUPER,f,togglefloating,"

        # Resize window (Super+Ctrl + vim keys); moves the split in tiled layouts
        "SUPER+CTRL,h,resizewin,-50,+0"
        "SUPER+CTRL,l,resizewin,+50,+0"
        "SUPER+CTRL,k,resizewin,+0,-50"
        "SUPER+CTRL,j,resizewin,+0,+50"
      ]
      # Move window to workspace N with Super+Shift+N
      ++ map (id: "SUPER+SHIFT,${toString id},tag,${toString id},0") (builtins.genList (i: i + 1) 9);

      # Super + left-drag to move, Super + right-drag to resize
      mousebind = [
        "SUPER,btn_left,moveresize,curmove"
        "SUPER,btn_right,moveresize,curresize"
      ];
    };

    # Written to ~/.config/mango/autostart.sh; the module adds the exec-once line.
    autostart_sh = ''
      waybar >/dev/null 2>&1 &
      swaybg -i ${./walls/chaos.png} -m fill &
    '';
  };
}
