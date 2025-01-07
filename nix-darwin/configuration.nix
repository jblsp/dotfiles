{
  pkgs,
  config,
  ...
}: {
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
  };

  nix.settings.experimental-features = "nix-command flakes";

  users.users = {
    "joe" = {
      home = "/Users/joe";
      description = "Joe Sparma";
    };
  };

  environment.systemPackages = with pkgs; [
    cowsay
    (discord.override {
      withVencord = true;
    })
    fastfetch
    jdk
    gh
    aerospace
    lazygit
    alejandra
  ];

  environment.pathsToLink = ["/share/zsh"];

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  networking = {
    computerName = "Joe's MacBook Pro";
    knownNetworkServices = ["Wi-Fi"];
    dns = ["8.8.8.8" "8.8.4.4"];
  };

  system.defaults.finder = {
    NewWindowTarget = "Home";
    _FXShowPosixPathInTitle = true;
    _FXSortFoldersFirst = true;
    FXPreferredViewStyle = "Nlsv";
    FXDefaultSearchScope = "SCcf";
  };

  system.defaults.WindowManager.EnableTiledWindowMargins = false;

  system.defaults.NSGlobalDomain = {
    ApplePressAndHoldEnabled = false;
    InitialKeyRepeat = 22;
    KeyRepeat = 3;
    AppleShowAllExtensions = true;
    "com.apple.trackpad.forceClick" = false;
  };

  system.defaults.controlcenter = {
    BatteryShowPercentage = true;
    Sound = true;
  };

  system.defaults.dock = {
    autohide = true;
    autohide-delay = 0.05;
    autohide-time-modifier = 0.75;
    mineffect = "scale";
    minimize-to-application = true;
    show-recents = false;
    showhidden = true;
    tilesize = 52;
    persistent-apps = [
      "/Applications/Ghostty.app"
      "/Applications/Zen Browser.app"
    ];
    persistent-others = [
      "/Users/joe/Downloads/"
    ];
  };
  system.defaults.CustomUserPreferences."com.apple.dock"."enterMissionControlByTopWindowDrag" = 0;

  system.defaults.CustomUserPreferences."com.apple.Spotlight"."orderedItems" = [
    {
      enabled = 1;
      name = "APPLICATIONS";
    }
    {
      enabled = 1;
      name = "MENU_EXPRESSION";
    }
    {
      enabled = 0;
      name = "CONTACT";
    }
    {
      enabled = 1;
      name = "MENU_CONVERSION";
    }
    {
      enabled = 1;
      name = "MENU_DEFINITION";
    }
    {
      enabled = 0;
      name = "SOURCE";
    }
    {
      enabled = 0;
      name = "DOCUMENTS";
    }
    {
      enabled = 0;
      name = "EVENT_TODO";
    }
    {
      enabled = 0;
      name = "DIRECTORIES";
    }
    {
      enabled = 0;
      name = "FONTS";
    }
    {
      enabled = 0;
      name = "IMAGES";
    }
    {
      enabled = 0;
      name = "MESSAGES";
    }
    {
      enabled = 0;
      name = "MOVIES";
    }
    {
      enabled = 0;
      name = "MUSIC";
    }
    {
      enabled = 1;
      name = "MENU_OTHER";
    }
    {
      enabled = 0;
      name = "PDF";
    }
    {
      enabled = 0;
      name = "PRESENTATIONS";
    }
    {
      enabled = 0;
      name = "MENU_SPOTLIGHT_SUGGESTIONS";
    }
    {
      enabled = 0;
      name = "SPREADSHEETS";
    }
    {
      enabled = 1;
      name = "SYSTEM_PREFS";
    }
    {
      enabled = 0;
      name = "TIPS";
    }
    {
      enabled = 0;
      name = "BOOKMARKS";
    }
  ];

  system.defaults.CustomUserPreferences."com.apple.desktopservices" = {
    DSDontWriteNetworkStores = true;
    DSDontWriteUSBStores = true;
  };

  system.defaults.CustomUserPreferences."com.apple.AdLib" = {
    allowApplePersonalizedAdvertising = false;
    allowIdentifierForAdvertising = false;
  };

  system.defaults.CustomUserPreferences."com.apple.assistant.support"."Search Queries Data Sharing Status" = 2;

  system.stateVersion = 5;
}
