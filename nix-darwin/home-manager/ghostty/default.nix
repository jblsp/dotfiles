{config, ...}: {
  xdg.configFile.ghostty.source = config.lib.file.mkOutOfStoreSymlink /Users/joe/dotfiles/ghostty;
}
