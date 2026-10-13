{ config, pkgs, ... }:

{
  programs.omp = {
    enable = true;
    settings.startup.quiet = true;
  };

  # The omp HM module doesn't ship completions, so generate them at build time.
  xdg.configFile."fish/completions/omp.fish".source =
    pkgs.runCommand "omp-fish-completions" { } ''
      HOME=$TMPDIR ${config.programs.omp.package}/bin/omp completions fish > $out
    '';
}
