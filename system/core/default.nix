{
  # This way it forks immediately and doesn't slow down boot
  networking.dhcpcd.wait = "background";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.nick = {
     isNormalUser = true;
     extraGroups = [ "wheel" "libvirtd"]; 
  };

  # no change this
  system.stateVersion = "23.11";
}
