{
  inputs,
  config,
  ...
}: {
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "joe";
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    caskArgs.appdir = "/Applications/Homebrew";
    casks = [
      "ghostty"
      "bitwarden"
      "zen-browser"
      "libreoffice"
      "steam"
    ];
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
