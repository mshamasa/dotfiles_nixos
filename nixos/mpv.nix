{
  programs.mpv = {
    enable = true;

    config = {
      # hardware decoding on the radeon igpu
      hwdec = "auto-safe";
      vo = "gpu-next";
      # remember playback position when quitting
      save-position-on-quit = true;
      keep-open = true;
    };
  };
}
