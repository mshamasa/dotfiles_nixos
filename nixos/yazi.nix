{
  programs.yazi = {
    enable = true;
    # adds the `y` wrapper to fish: cd's into the last dir when you quit yazi
    enableFishIntegration = true;

    settings = {
      opener = {
        play = [
          {
            run = ''mpv "$@"'';
            orphan = true;
            for = "unix";
          }
        ];
        view = [
          {
            run = ''imv "$@"'';
            orphan = true;
            for = "unix";
          }
        ];
      };
      # open videos/audio with mpv and images with imv
      open.prepend_rules = [
        { mime = "video/*"; use = "play"; }
        { mime = "audio/*"; use = "play"; }
        { mime = "image/*"; use = "view"; }
      ];
    };
  };
}
