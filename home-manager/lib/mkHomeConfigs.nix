{
  home-manager,
  flake,
  mkpkgs,
}: specs:
builtins.listToAttrs (builtins.map ({
    hostname,
    system,
    username ? "joe",
    name ? "${username}@${hostname}",
    config ? {},
  }: let
    isDarwin = builtins.match ".*-darwin" system != null;
    pkgs = mkpkgs system;
    lib = flake.inputs.nixpkgs.lib;
  in {
    inherit name;
    value = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        {
          home = {
            inherit username;
            homeDirectory =
              if isDarwin
              then "/Users/${username}/"
              else "/home/${username}/";
          };
        }
        ../config
        config
      ];
      extraSpecialArgs = {
        inherit flake;
      };
    };
  })
  specs)
