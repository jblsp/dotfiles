{
  flake,
  lib,
  config,
  ...
}: let
  nixGL-overlay = final: prev:
    builtins.listToAttrs (builtins.map (name: {
        inherit name;
        value = config.lib.nixGL.wrap prev.${name};
      }) [
        "ghostty"
        "firefox"
      ]);
in {
  nixpkgs.overlays = lib.optional config.targets.genericLinux.enable nixGL-overlay;
  nixGL.packages = flake.inputs.nixGL.packages;
}
