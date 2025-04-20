pkgs: let
  extraPackages = with pkgs; [
    # Neovim Dependencies
    ripgrep

    # Lazy dependencies
    git
    luarocks

    # Treesitter dependencies
    gcc

    # Language Servers
    bash-language-server
    jdt-language-server
    lua-language-server
    marksman
    nixd
    pyright
    roslyn-ls
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server

    # Formatters
    alejandra
    black
    isort
    nodePackages.prettier
    stylua

    # Linters
    markdownlint-cli2
    selene
  ];
in
  pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
    wrapRc = false;
    wrapperArgs = ''--prefix PATH : "${pkgs.lib.makeBinPath extraPackages}"'';
  }
