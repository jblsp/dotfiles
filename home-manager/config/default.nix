{
  lib,
  config,
  flake,
  ...
}: {
  imports = [
    ./firefox.nix
    ./ghostty.nix
    ./nixcord.nix
  ];

  nixpkgs = {
    overlays =
      [
        (import ../overlays/mypkgs.nix)
        flake.inputs.nur.overlays.default
      ]
      ++ lib.optional config.targets.genericLinux.enable (import ../overlays/nixgl.nix config.lib.nixGL.wrap);
    config = {
      allowUnfree = true;
    };
  };

  nixGL.packages = flake.inputs.nixGL.packages;

  home = {
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
