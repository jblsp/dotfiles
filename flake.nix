{
  description = "Home Manager configuration of joe";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

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
    betterfox = {
      url = "github:HeitorAugustoLN/betterfox-nix";
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
        config = {lib, ...}: {
          imports = [
            ./home-manager/presets/desktop.nix
            ./home-manager/presets/linux.nix
            ./home-manager/programs/kitty.nix
          ];
          targets.genericLinux.enable = true;
          programs.nixcord.enable = lib.mkForce false;
          programs.ghostty.enable = lib.mkForce false;
        };
      };
      "joe" = mkConfig {
        system = "aarch64-darwin";
        config = {...}: {
          imports = [./home-manager/presets/desktop.nix];
          programs.ghostty = {
            settings.font-size = 20;
          };
        };
      };
    };
  };
}
