{ inputs, config, ... }: {
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
     casks = [
       "ghostty"
       "bitwarden"
       "zen-browser"
     ];
     onActivation = {
       cleanup = "zap";
       autoUpdate = true;
       upgrade = true;
     };
   };
}
