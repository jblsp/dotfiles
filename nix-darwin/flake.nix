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

  outputs = inputs @ {
    self,
    nix-darwin,
    home-manager,
    nix-homebrew,
    ...
  }: let
    hostName = "JMBP";
  in {
    darwinConfigurations."${hostName}" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        {
          networking.hostName = hostName;
          system.configurationRevision = self.rev or self.dirtyRev or null;
        }
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.joe = import ./home.nix;
          };
        }
        nix-homebrew.darwinModules.nix-homebrew
        ./homebrew.nix
      ];
    };
  };
}
