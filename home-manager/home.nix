{flake, ...}: {
  nixpkgs = {
    overlays = [
      (import ./overlays/mypkgs.nix)
      flake.inputs.nur.overlays.default
    ];

    config = {
      allowUnfree = true;
    };
  };

  imports = [
    flake.inputs.mac-app-util.homeManagerModules.default
    ./config
  ];

  home = {
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
