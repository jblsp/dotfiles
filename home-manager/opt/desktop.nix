{pkgs, ...}: {
  home.packages = with pkgs; [
    (callPackage ../pkgs/nvim.nix {})
  ];

  programs = {
    firefox.enable = true;
    ghostty.enable = true;
    zsh.enable = true;
    oh-my-posh.enable = true;
    nixcord.enable = true;
    git.enable = true;
  };
}
