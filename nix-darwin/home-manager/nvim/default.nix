{
  pkgs,
  config,
  ...
}: {
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

  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink ./.;
}
