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
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util/link-contents";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: {
    homeConfigurations = let
      mkConfig = {
        system ? "x86_64-linux",
        config ? {},
      }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {inherit system;};
          modules = [config ./home-manager/core];
          extraSpecialArgs = {flake = self;};
        };
    in {
      "joe@JT1" = mkConfig {
        config = {...}: {
          imports = [./home-manager/opt/desktop.nix];
          targets.genericLinux.enable = true;
        };
      };
      "joe@JMBP" = mkConfig {
        system = "aarch64-darwin";
        config = {...}: {
          imports = [./home-manager/opt/desktop.nix];
          programs.librewolf.package = null;
          programs.ghostty = {
            package = null;
            settings.font-size = 20;
          };
        };
      };
    };
  };
}
