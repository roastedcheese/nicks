{ inputs, pkgs, ... }:
{

  programs.firefox.profiles = {
    schizo = { 
      isDefault = true;
      search = import ./modules/search.nix;

      extraConfig = import ./modules/overrides.nix + ''
        user_pref("media.peerconnection.ice.no_host", true);
      ''; # Overrides for arkenfox's user.js, we have to set them with extraConfig because otherwise they'll end up before the other options

      extensions = builtins.attrValues {
        inherit (inputs.firefox-addons.packages.${pkgs.system}) 
          ublock-origin darkreader noscript localcdn indie-wiki-buddy ff2mpv vimium firefox-color;
      };
    };
    
    logins = { # Slightly less schizophrenic, only used for certain websites
      id = 1;
      search = import ./modules/search.nix;

      extraConfig = import ./modules/overrides.nix + ''
        user_pref("privacy.resistFingerprinting", false);
        user_pref("privacy.sanitize.sanitizeOnShutdown", false);
        user_pref("privacy.antitracking.enableWebcompat", false);
      '';

      extensions = builtins.attrValues {
        inherit (inputs.firefox-addons.packages.${pkgs.system}) 
          ublock-origin darkreader noscript localcdn firefox-color vimium;
      };
    };
  };
}
