{
  lib,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = lib.mkIf pkgs.stdenv.isDarwin null;
    settings = {
      auto-update = "off";
      font-feature = "-calt";
      mouse-hide-while-typing = true;
      shell-integration-features = "no-cursor";
      theme = "catppuccin-mocha";
      command = "${pkgs.zsh}/bin/zsh -i";
    };
  };
}
