{flake, ...}: {
  nixpkgs = {
    overlays = [
      flake.inputs.nur.overlays.default
    ];

    config = {
      allowUnfree = true;
    };
  };
}
