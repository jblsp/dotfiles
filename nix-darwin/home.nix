{ config, pkgs, ... }: {
  home = {
    username = "joe";
    homeDirectory = "/Users/joe";
  };

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      lua-language-server
      pyright
      stylua
      black
      isort
      prettierd
      selene
      pylint
      markdownlint-cli2
      jdt-language-server
    ];
  };
  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink /Users/joe/dotfiles/nvim;

  xdg.configFile.ghostty.source = config.lib.file.mkOutOfStoreSymlink /Users/joe/dotfiles/ghostty;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["colored-man-pages" "gitignore" ];
    };
    plugins = with pkgs; [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };

  xdg.configFile.git.source = config.lib.file.mkOutOfStoreSymlink /Users/joe/dotfiles/git;

  home.stateVersion = "24.11";
}

