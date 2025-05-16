{flake, ...}: {
  imports = [
    ./firefox.nix
    ./ghostty.nix
    ./nixGL.nix
    ./zsh.nix
    ./oh-my-posh.nix
    ./nixcord.nix
    ./git.nix
  ];

  nixpkgs = {
    overlays = [
      flake.inputs.nur.overlays.default
    ];

    config = {
      allowUnfree = true;
    };
  };

  home = {
    sessionPath = [
      "$HOME/.local/bin"
    ];
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
