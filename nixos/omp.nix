{ config, pkgs, ... }:

{
  programs.omp = {
    enable = true;
    settings.startup.quiet = true;
    # must match the model id in ~/.omp/agent/models.yml
    settings.modelRoles.default = "llama.cpp/unsloth/Qwen3.8-27B-GGUF:Q4_K_M";
    # config.yml is overwritten on every activation; without this omp
    # forgets the setup wizard was completed and shows it again
    settings.setupVersion = 2;
  };

  # The omp HM module doesn't ship completions, so generate them at build time.
  xdg.configFile."fish/completions/omp.fish".source = pkgs.runCommand "omp-fish-completions" { } ''
    HOME=$TMPDIR ${config.programs.omp.package}/bin/omp completions fish > $out
  '';
}
