{pkgs, ...}: {
  home.packages = with pkgs; [
    mypkgs.nvim
  ];
  programs = {
    ghostty.enable = true;
    firefox.enable = true;
  };
}
