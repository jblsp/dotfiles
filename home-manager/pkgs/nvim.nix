{
  pkgs,
  wrapNeovimUnstable,
  neovim-unwrapped,
  lib,
}: let
  extraPackages = with pkgs; [
    # Neovim Dependencies
    ripgrep

    # lazy-nvim dependencies
    git
    luarocks

    # nvim-treesitter dependencies
    gcc

    # fzf-lua depedencies
    fzf

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
  wrapNeovimUnstable neovim-unwrapped {
    wrapRc = false;
    wrapperArgs = ''--prefix PATH : "${lib.makeBinPath extraPackages}"'';
  }
