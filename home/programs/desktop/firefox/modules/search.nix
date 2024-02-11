{
  force = true;
  default = "Searx";
  order = [ "Invidious" "Searx" "nixpkgs" "hm options search" ];

  engines = {
    "Invidious" = {
      urls = [{ template = "https://yewtu.be/search?q={searchTerms}"; }];
      iconUpdateURL = "https://yewtu.be/favicon-32x32.png";
      updateInterval = 24 * 60 * 60 * 1000; # every day
    };

    "Searx" = {
      urls = [{ template = "https://searx.be/search?q={searchTerms}"; }];
      iconUpdateURL = "https://searx.be/static/themes/oscar/img/favicon.png";
      updateInterval = 24 * 60 * 60 * 1000; # every day
    };

    "nixpkgs" = {
      urls = [{ template = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}"; }];
      iconUpdateURL = "https://nixos.org/favicon.png";
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = [ "@np" ];
    };

    "hm options search" = {
      urls = [{ template = "https://mipmip.github.io/home-manager-option-search/?query={searchTerms}"; }];
      iconUpdateURL = "https://mipmip.github.io/home-manager-option-search/images/favicon.png";
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = [ "@hm" ];
    };
    "Bing".metaData.hidden = true;
    "Google".metaData.hidden = true;
    "Amazon.com".metaData.hidden = true;
    "DuckDuckGo".metaData.hidden = true;
    "eBay".metaData.hidden = true;
  };
}
