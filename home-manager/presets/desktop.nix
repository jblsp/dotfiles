{pkgs, ...}: {
  imports = [
    ../config/ghostty.nix
    ../config/git.nix
    ../config/go.nix
    ../config/librewolf.nix
    ../config/nixcord.nix
    ../config/oh-my-posh.nix
    ../config/zsh.nix
  ];

  home.packages = with pkgs; [
    (callPackage ../../nix/pkgs/nvim.nix {})
  ];
}
