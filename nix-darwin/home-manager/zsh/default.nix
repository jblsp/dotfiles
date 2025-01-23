{...}: {
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
      strategy = ["completion"];
    };
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["colored-man-pages" "gitignore"];
    };
    # plugins = [
    #   {
    #     name = "vi-mode";
    #     src = pkgs.zsh-vi-mode;
    #     file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
    #   }
    # ];
  };
}
