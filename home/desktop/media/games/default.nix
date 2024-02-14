{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs) steam prismlauncher heroic;
  };
}
