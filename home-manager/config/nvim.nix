{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      (callPackage ../../nix/pkgs/nvim.nix {})
    ];
    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
    shellAliases = {
      vi = "nvim";
    };
  };
}
