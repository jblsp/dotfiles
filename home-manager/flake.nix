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
        pkgs = system:
          import nixpkgs {
            inherit system;
            overlays = [inputs.nur.overlays.default];
          };
        extraSpecialArgs = {
          mylib = import ./lib/mylib.nix nixpkgs.lib;
          flake = self;
        };
      }
      [
        {
          hostname = "JMBP";
          system = "aarch64-darwin";
          config = {
            imports = [inputs.mac-app-util.homeManagerModules.default];
            programs.firefox.enable = true;
          };
        }
      ];
  };
}
