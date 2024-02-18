{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs) thunderbird element-desktop; # Ew electron
  };
}
