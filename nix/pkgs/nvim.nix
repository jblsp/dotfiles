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
    tree-sitter
    nodejs

    # fzf-lua depedencies
    fzf
    fd

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
    gopls

    # Formatters
    alejandra
    black
    isort
    nodePackages.prettier
    stylua
  ];
in
  wrapNeovimUnstable neovim-unwrapped {
    wrapRc = false;
    wrapperArgs = ''--prefix PATH : "${lib.makeBinPath extraPackages}"'';
  }
