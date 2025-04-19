{
  description = "Home Manager configuration of joe";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    inputs = self.inputs;
    mkHomeConfigs = import ./lib/mkHomeConfigs.nix;
  in {
    homeConfigurations =
      mkHomeConfigs {
        inherit home-manager;
        flake = self;
        mkpkgs = system:
          import nixpkgs {
            inherit system;
            overlays = [
              (import ./overlays/mypkgs.nix)
              inputs.nur.overlays.default
            ];
          };
      }
      [
        {
          hostname = "JMBP";
          system = "aarch64-darwin";
          config = {pkgs, ...}: {
            imports = [inputs.mac-app-util.homeManagerModules.default];
            home.packages = with pkgs; [
              nvim
            ];
            programs.firefox.enable = true;
          };
        }
      ];
  };
}
