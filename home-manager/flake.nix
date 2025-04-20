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
      url = "github:hraban/mac-app-util";
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
  }: let
    mkHomeConfigs = import ./lib/mkHomeConfigs.nix;
  in {
    homeConfigurations =
      mkHomeConfigs {
        inherit nixpkgs;
        inherit home-manager;
        flake = self;
      }
      [
        {
          hostname = "JMBP";
          system = "aarch64-darwin";
          config = {...}: {
            imports = [
              ./modules/desktop.nix
            ];
            programs.ghostty = {
              package = null;
              settings.font-size = 20;
            };
          };
        }
        {
          hostname = "JZB";
          system = "x86_64-linux";
          config = {pkgs, ...}: {
            targets.genericLinux.enable = true;
            home.packages = with pkgs; [
              mypkgs.nvim
            ];
            programs.firefox.enable = true;
            programs.ghostty.enable = true;
            programs.nixcord.enable = true;
          };
        }
      ];
  };
}
