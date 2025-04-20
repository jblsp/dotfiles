{flake, ...}: {
  imports = [
    ./firefox.nix
    ./ghostty.nix
    ./discord.nix
  ];

  nixpkgs = {
    overlays = [
      (import ../overlays/mypkgs.nix)
      flake.inputs.nur.overlays.default
    ];
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
