{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
in {
  imports = [
    ./nvidia.nix
    ./opengl.nix
  ];

  options.opt.hardware.displays = mkOption {
    type = types.attrsOf (types.strMatching "^[[:digit:]]{1,4}x[[:digit:]]{1,4}@[[:digit:]]{1,3}$");
    default = {};
    description = "define display names, resolution and refresh rate";
    example = {"" = "x1920x1080@60";};
  };
}
