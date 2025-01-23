{
  description = "My nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs = {
    self,
    nix-darwin,
    ...
  }: let
    mkDarwin = {
      hostName,
      userName,
    }:
      nix-darwin.lib.darwinSystem {
        specialArgs = {
          flake = self;
          inherit hostName;
          inherit userName;
          root = ./.;
        };
        modules = [
          ./nixos/hosts/${hostName}
        ];
      };
  in {
    darwinConfigurations = {
      "JMBP" = mkDarwin {
        hostName = "JMBP";
        userName = "joe";
      };
    };
  };
}
