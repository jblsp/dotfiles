{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.jetbrains-mono;
      name = "Jetbrains Mono";
    };
    themeFile = "Catppuccin-Mocha";
    shellIntegration.mode = "no-cursor";
    settings = {
      shell = "${pkgs.zsh}/bin/zsh -i";
    };
  };
}
