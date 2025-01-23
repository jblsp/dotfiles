{
  pkgs,
  config,
  hostName,
  flake,
  root,
  userName,
  ...
}: {
  imports = [
    flake.inputs.home-manager.darwinModules.home-manager
    (root + /homebrew.nix)
  ];

  networking.hostName = hostName;
  system.configurationRevision = flake.rev or flake.dirtyRev or null;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${userName} = {...}: {
      imports = let
        hm = root + /home-manager;
      in [
        (hm + /nvim)
        (hm + /gh)
        (hm + /git)
        (hm + /zsh)
        (hm + /ghostty)
      ];

      home = {
        username = "joe";
        homeDirectory = "/Users/joe";
      };

      programs.home-manager.enable = true;

      home.stateVersion = "24.11";
    };

    extraSpecialArgs = {inherit flake;};
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config = {
      allowUnfree = true;
      # allowBroken = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  users.users = {
    "${userName}" = {
      home = "/Users/${userName}";
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
    lazygit
    alejandra
    python3
    ghc
    yazi
    tokei
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
      rm -rf /Applications/Nix
      mkdir -p /Applications/Nix
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix/$app_name"
      done
    '';

  networking = {
    computerName = "Joe's MacBook Pro";
    knownNetworkServices = ["Wi-Fi"];
    dns = ["8.8.8.8" "8.8.4.4"];
  };

  services.aerospace = {
    enable = true;
    settings = {
    };
  };

  system.defaults.finder = {
    NewWindowTarget = "Home";
    _FXShowPosixPathInTitle = true;
    _FXSortFoldersFirst = true;
    FXPreferredViewStyle = "Nlsv";
    FXDefaultSearchScope = "SCcf";
  };

  system.defaults.screencapture.show-thumbnail = false;
  system.defaults.screensaver.askForPasswordDelay = 15;

  system.defaults.WindowManager.EnableTiledWindowMargins = false;

  system.defaults.NSGlobalDomain = {
    ApplePressAndHoldEnabled = false;
    InitialKeyRepeat = 22;
    KeyRepeat = 3;
    NSDocumentSaveNewDocumentsToCloud = false;
    AppleShowAllExtensions = true;
    "com.apple.trackpad.forceClick" = false;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticInlinePredictionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
  };
  system.defaults.CustomUserPreferences."com.apple.preference.trackpad" = {
    ForceClickSavedState = 0;
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
      "/Applications/Homebrew/Ghostty.app"
      "/Applications/Homebrew/Zen Browser.app"
    ];
    persistent-others = [
      "/Users/joe/Downloads/"
    ];
    expose-group-apps = true; # mission control group windows by app
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
  };
  system.defaults.CustomUserPreferences."com.apple.dock"."enterMissionControlByTopWindowDrag" = 0;

  # I just copied these defaults after setting the touchpad settings that I like,
  # not sure if writing these actually applies the settings I want
  system.defaults.CustomUserPreferences."com.apple.AppleMultitouchTrackpad" = {
    TrackpadFiveFingerPinchGesture = 0;
    TrackpadFourFingerHorizSwipeGesture = 0;
    TrackpadFourFingerPinchGesture = 0;
    TrackpadFourFingerVertSwipeGesture = 0;
    TrackpadThreeFingerHorizSwipeGesture = 0;
    TrackpadThreeFingerTapGesture = 2;
    TrackpadThreeFingerVertSwipeGesture = 0;
    TrackpadTwoFingerDoubleTapGesture = 0;
    TrackpadTwoFingerFromRightEdgeSwipeGesture = 0;
  };

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
