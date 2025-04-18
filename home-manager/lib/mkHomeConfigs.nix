let
  configDir = ../configs;
  configs = builtins.map (name: configDir + "/${name}") (builtins.attrNames (builtins.readDir configDir));
in
  {
    home-manager,
    pkgs,
    extraSpecialArgs ? {},
  }: specs:
    builtins.listToAttrs (builtins.map ({
        hostname,
        system,
        username ? "joe",
        name ? "${username}@${hostname}",
        config ? {},
      }: {
        inherit name;
        value = let
          isDarwin = builtins.match ".*-darwin" system != null;
        in
          home-manager.lib.homeManagerConfiguration {
            pkgs = pkgs system;
            modules = [
              {
                imports = configs;
                home = {
                  inherit username;
                  homeDirectory =
                    if isDarwin
                    then "/Users/${username}/"
                    else "/home/${username}/";
                };
              }
              ../home.nix
              config
            ];
            inherit extraSpecialArgs;
          };
      })
      specs)
