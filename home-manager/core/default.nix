{flake, ...}: {
  imports = [
    flake.inputs.mac-app-util.homeManagerModules.default
    ./nixGL.nix
    ./nixpkgs.nix
    ./home.nix
  ];

  programs.home-manager.enable = true;
}
