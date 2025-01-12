{
  config,
  pkgs,
  ...
}: {
  home = {
    username = "joe";
    homeDirectory = "/Users/joe";
  };

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      # Telescope dependencies
      fd

      # Language servers
      lua-language-server
      pyright
      jdt-language-server
      haskell-language-server
      nixd

      # Formatters
      stylua
      black
      isort
      prettierd
      alejandra

      # Linters
      selene
      pylint
      markdownlint-cli2
    ];
  };
  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink /Users/joe/dotfiles/nvim;

  xdg.configFile.ghostty.source = config.lib.file.mkOutOfStoreSymlink /Users/joe/dotfiles/ghostty;

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

  programs.git = {
    enable = true;
    userName = "Joe";
    userEmail = "48526917+jblsp@users.noreply.github.com";
    ignores = [
      ".DS_Store"
      "*.swp"
    ];
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = ["https://github.com" "https://github.example.com"];
    };
  };

  home.stateVersion = "24.11";
}
