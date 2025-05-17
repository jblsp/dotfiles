{
  config,
  pkgs,
  flake,
  ...
}: {
  imports = [
    flake.inputs.mac-app-util.homeManagerModules.default
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
    username = "joe";
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${config.home.username}/"
      else "/home/${config.home.username}/";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
