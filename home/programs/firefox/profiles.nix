{

  programs.firefox.profiles.schizo = { 
  # Overrides for arkenfox's user.js, we have to set them with extraConfig because otherwise they'll end up before the other options
    extraConfig = ''
      user_pref("_user.js.parrot", "NIX: The parrot is finally home"); // Test pref for home-manager overrides
    '';
  };
}
