{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.opt.programs.firefox;
  extensions = builtins.attrValues {
    inherit
      (inputs.firefox-addons.packages.${pkgs.system})
      ublock-origin
      darkreader
      noscript
      localcdn
      indie-wiki-buddy
      ff2mpv
      tridactyl
      firefox-color
      ;
  };

  search = {
    force = true;
    default = "Searx";
    order = ["Invidious" "Searx" "nixpkgs" "hm options search"];

    engines = {
      "Invidious" = {
        urls = [{template = "https://yewtu.be/search?q={searchTerms}";}];
        iconUpdateURL = "https://yewtu.be/favicon-32x32.png";
        updateInterval = 24 * 60 * 60 * 1000; # every day
        definedAliases = ["@iv"];
      };

      "Searx" = {
        urls = [{template = "https://searx.be/search?q={searchTerms}";}];
        iconUpdateURL = "https://searx.be/static/themes/oscar/img/favicon.png";
        updateInterval = 24 * 60 * 60 * 1000; # every day
      };

      "nixpkgs" = {
        urls = [{template = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";}];
        iconUpdateURL = "https://nixos.org/favicon.png";
        updateInterval = 24 * 60 * 60 * 1000; # every day
        definedAliases = ["@np"];
      };
      "NixOS" = {
        urls = [{template = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";}];
        iconUpdateURL = "https://nixos.org/favicon.png";
        updateInterval = 24 * 60 * 60 * 1000; # every day
        definedAliases = ["@nx"];
      };

      "hm options search" = {
        urls = [{template = "https://home-manager-options.extranix.com/?query={searchTerms}";}];
        iconUpdateURL = "https://mipmip.github.io/home-manager-option-search/images/favicon.png";
        updateInterval = 24 * 60 * 60 * 1000; # every day
        definedAliases = ["@hm"];
      };
      "Bing".metaData.hidden = true;
      "Google".metaData.hidden = true;
      "Amazon.com".metaData.hidden = true;
      "DuckDuckGo".metaData.hidden = true;
      "eBay".metaData.hidden = true;
    };
  };

  overrides =
    (builtins.readFile (inputs.self.lib.niv."user.js" + "/user.js"))
    + ''
      user_pref("_user.js.parrot", "NIX: The parrot is finally home"); // Test pref for home-manager overrides
      user_pref("browser.search.suggest.enabled", true);
      user_pref("browser.urlbar.suggest.searches", true);
      user_pref("browser.cache.disk.enable", false);

      // Breaks Video Conferencing platforms
      // user_pref("media.peerconnection.ice.no_host", true);

      // if you need to use non-latin alphabets with punycoded characters
      // user_pref("network.IDN_show_punycode", false);

      /* 2702: disable ETP web compat features [FF93+]
       * [SETUP-HARDEN] Includes skip lists, heuristics (SmartBlock) and automatic grants
       * Opener and redirect heuristics are granted for 30 days, see [3]
       * [1] https://blog.mozilla.org/security/2021/07/13/smartblock-v2/
       * [2] https://hg.mozilla.org/mozilla-central/rev/e5483fd469ab#l4.12
       * [3] https://developer.mozilla.org/en-US/docs/Web/Privacy/State_Partitioning#storage_access_heuristics ***/
       user_pref("privacy.antitracking.enableWebcompat", true);

      /* [SETUP-WEB] RFP can cause some website breakage: mainly canvas, use a canvas site exception via the urlbar.
       * RFP also has a few side effects: mainly timezone is UTC, and websites will prefer light theme
       * [NOTE] pbmode applies if true and the original pref is false
       * [1] https://bugzilla.mozilla.org/418986 ***/
      // user_pref("privacy.resistFingerprinting", false);

      user_pref("browser.search.hiddenOneOffs", "Google,Amazon,DuckDuckGo,Wikipedia,Bing");
      user_pref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned", "");
      user_pref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines", "");
      user_pref("browser.search.separatePrivateDefault", false);
      user_pref("browser.urlbar.suggest.engines", false);
      user_pref("browser.search.region", "US");
      user_pref("extensions.autoDisableScopes", 0);
      user_pref("signon.rememberSignons", false);
      user_pref("_user.js.parrot", "overrides");
    '';
in {
  options.opt.programs.firefox.enable = mkEnableOption "firefox";

  config.home-manager.users.${config.opt.system.username} = {
    programs.firefox = mkIf cfg.enable {
      enable = true;
      profiles = {
        schizo = {
          isDefault = true;
          inherit extensions search;

          extraConfig =
            overrides
            + ''
              user_pref("media.peerconnection.ice.no_host", true);
              user_pref("_user.js.parrot", "b");
            ''; # Overrides for arkenfox's user.js, we have to set them with extraConfig because otherwise they'll end up before the other options
        };

        logins = {
          # Slightly less schizophrenic, only used for certain websites
          id = 1;
          inherit search extensions;

          extraConfig =
            overrides
            + ''
              user_pref("privacy.resistFingerprinting", false);
              user_pref("privacy.sanitize.sanitizeOnShutdown", false);
              user_pref("privacy.antitracking.enableWebcompat", false);
              user_pref("browser.startup.page", 3); # Resume previous session
              user_pref("_user.js.parrot", "b");
            '';
        };

        trackers = {
          id = 2;
          extensions =
            extensions
            ++ [
              inputs.firefox-addons.packages.${pkgs.system}.violentmonkey
            ];

          search = {
            force = true;
            default = "Searx";
            order = ["OPS" "Discogs" "MusicBrainz Release Group" "MusicBrainz Artist" "Qobuz" "Searx"];
            engines = {
              "Searx" = {
                urls = [{template = "https://searx.be/search?q={searchTerms}";}];
                iconUpdateURL = "https://searx.be/static/themes/oscar/img/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000;
              };

              "OPS" = {
                urls = [{template = "https://orpheus.network/torrents.php?searchstr={searchTerms}";}];
                iconUpdateURL = "https://interview.orpheus.network/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
              };

              "Discogs" = {
                urls = [{template = "https://www.discogs.com/search?q={searchTerms}&type=all";}];
                iconUpdateUrl = "https://discogs.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
              };

              "MusicBrainz Release Group" = {
                urls = [{template = "https://musicbrainz.org/search?query={searchTerms}&type=release_group";}];
                iconUpdateUrl = "https://musicbrainz.org/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
              };

              "MusicBrainz Artist" = {
                urls = [{template = "https://musicbrainz.org/search?query={searchTerms}&type=artist";}];
                iconUpdateUrl = "https://musicbrainz.org/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
              };

              "Qobuz" = {
                urls = [{template = "https://www.qobuz.com/it-it/search?q={searchTerms}";}];
                iconUpdateUrl = "https://www.qobuz.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
              };
              "Bing".metaData.hidden = true;
              "Google".metaData.hidden = true;
              "Amazon.com".metaData.hidden = true;
              "DuckDuckGo".metaData.hidden = true;
              "eBay".metaData.hidden = true;
            };
          };

          extraConfig =
            overrides
            + ''
              user_pref("privacy.resistFingerprinting", false);
              user_pref("privacy.sanitize.sanitizeOnShutdown", false);
              user_pref("privacy.antitracking.enableWebcompat", false);
              user_pref("_user.js.parrot", "trackers");
            '';
        };
        misc.id = 3;
      };
    };

    xdg.desktopEntries = let
      profile = name: {
        name = "Firefox (${name})";
        type = "Application";
        exec = "${pkgs.firefox}/bin/firefox -P ${name}";
      };
    in {
      firefox-logins = profile "logins";
      firefox-trackers = profile "trackers";
      firefox-misc = profile "misc";
    };
  };
}
