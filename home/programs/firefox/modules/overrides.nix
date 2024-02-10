# Overrides for arkenfox's user.js; these are used on all profiles, others are applied locally based on schizophrenia level
''
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
''
