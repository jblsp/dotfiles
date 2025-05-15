{...}: {
  programs.ghostty = {
    settings = {
      auto-update = "off";
      font-feature = "-calt";
      mouse-hide-while-typing = true;
      shell-integration-features = "no-cursor";
      theme = "catppuccin-mocha";
      command = "zsh -i";
    };
  };
}
