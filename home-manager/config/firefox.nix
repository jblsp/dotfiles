{pkgs, ...}: {
  programs.firefox = {
    policies = {
      DisableFirefoxStudies = true;
      DisableTelemetry = true;
    };
    profiles = {
      "joe" = {
        id = 0;
        isDefault = true;
        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            # bypass-paywalls-clean
            bitwarden
            darkreader
            return-youtube-dislikes
            sponsorblock
            ublock-origin
            unpaywall
            youtube-recommended-videos # unhook
            (buildFirefoxXpiAddon {
              pname = "bypass-paywalls-clean";
              version = "3.9.6.0";
              addonId = "magnolia@12.34";
              url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-4.1.2.0.xpi&inline=false&commit=591fb10fb9760e0d23242ea80397f656e37f7744";
              sha256 = "76c39428071aa085f1f0ed6f2dde3b9a6a7bff27957262030f8c317248b1649f";
              meta = with pkgs.lib; {
                homepage = "https://twitter.com/Magnolia1234B";
                description = "Bypass Paywalls of (custom) news sites";
                license = licenses.mit;
                platforms = platforms.all;
              };
            })
          ];
        };
        search = {
          force = true;
          default = "ddg";
          engines = {
            "bing".metaData.hidden = true;
            "google".metaData.alias = "@g";
            "wikipedia".metaData.alias = "@wp";
            "youtube" = {
              urls = [{template = "https://www.youtube.com/results?search_query={searchTerms}";}];
              icon = "https://youtube.com/favicon.ico";
              definedAliases = ["@yt" "@youtube"];
            };
            "reddit" = {
              urls = [{template = "https://reddit.com/search?q={searchTerms}";}];
              icon = "https://reddit.com/favicon.ico";
              definedAliases = ["@reddit"];
            };
            "Nix Packages" = {
              urls = [{template = "https://search.nixos.org/packages?query={searchTerms}";}];
              icon = "https://nixos.org/favicon.png";
              definedAliases = ["@np" "@nixpkgs"];
            };
            "NixOS Options" = {
              urls = [{template = "https://search.nixos.org/packages?query={searchTerms}";}];
              icon = "https://nixos.org/favicon.png";
              definedAliases = ["@no" "@nixos options"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
              icon = "https://nixos.wiki/favicon.png";
              definedAliases = ["@nw" "@nixos wiki"];
            };
            "ChatGPT" = {
              urls = [{template = "https://chat.openai.com/?q={searchTerms}";}];
              icon = "https://chat.openai.com/favicon.ico";
              definedAliases = ["@cgpt" "@chatgpt"];
            };
            "SearXNG" = {
              urls = [{template = "https://baresearch.org/search?q={searchTerms}";}];
              icon = "https://raw.githubusercontent.com/searxng/searxng/master/src/brand/searxng-wordmark.svg";
              definedAliases = ["@searxng" "@sx"];
            };
            "Baseball Reference" = {
              urls = [{template = "https://www.baseball-reference.com/search/search.fcgi?hint=&search={searchTerms}";}];
              icon = "https://www.baseball-reference.com/favicon.ico";
              definedAliases = ["@br" "@bref" "@baseballreference"];
            };
            "Pro Football Reference" = {
              urls = [{template = "https://www.pro-football-reference.com/search/search.fcgi?hint=&search={searchTerms}";}];
              icon = "https://www.pro-football-reference.com/favicon.ico";
              definedAliases = ["@pfr" "@profootballreference"];
            };
            "College Football @ Sports Reference" = {
              urls = [{template = "https://www.sports-reference.com/cfb/search/search.fcgi?hint=&search={searchTerms}";}];
              icon = "https://www.sports-reference.com/cfb/favicon.ico";
              definedAliases = ["@cfr" "@cfbr" "@collegefootballreference"];
            };
            "Arch Wiki" = {
              urls = [{template = "https://wiki.archlinux.org/index.php?search={searchTerms}";}];
              icon = "https://wiki.archlinux.org/favicon.ico";
              definedAliases = ["@archw" "@archwiki"];
            };
            "Home Manager Option Search" = {
              urls = [{template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";}];
              icon = "https://nixos.org/favicon.png";
              definedAliases = ["@hmo" "@homemanageroptions"];
            };
            "GitHub" = {
              urls = [{template = "https://github.com/search?q={searchTerms}&type=repositories";}];
              icon = "https://github.com/favicon.ico";
              definedAliases = ["@gh" "@github"];
            };
          };
        };
        settings = {
          # Enable installed extensions
          "extensions.autoDisableScopes" = 0;

          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.warnOnQuit" = false;
          "browser.preferences.moreFromMozilla" = false;
          "browser.aboutConfig.showWarning" = false;
          "browser.aboutwelcome.enabled" = false;
          "browser.formfill.enable" = false;

          # URL Bar
          "browser.urlbar.suggest.history" = false;
          "browser.urlbar.suggest.clipboard" = false;
          "browser.urlbar.suggest.openpage" = false;
          "browser.urlbar.suggest.engines" = false;
          "browser.urlbar.suggest.searches" = false;

          # Disable built-in password manager
          "signon.rememberSignons" = false;
          "signon.formlessCapture.enabled" = false;

          # Home page
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.feeds.system.topstories" = false;

          # Tab Sidebar
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;

          # reject cookie banners if one-click option
          "cookiebanners.service.mode" = 1;
          "cookiebanners.service.mode.privateBrowsing" = 1;

          # Instant fullscreen
          "full-screen-api.transition-duration.enter" = "0 0";
          "full-screen-api.transition-duration.leave" = "0 0";

          # Show all matches in find
          "findbar.highlightAll" = true;

          # Tabs
          # "browser.tabs.closeWindowWithLastTab" = false;
        };
      };
    };
  };
}
