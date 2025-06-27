{flake, ...}: {
  imports = [
    flake.inputs.mac-app-util.homeManagerModules.default
    flake.inputs.betterfox.homeManagerModules.betterfox
    ./nixGL.nix
    ./nixpkgs.nix
    ./home.nix
  ];

  programs.home-manager.enable = true;
}
