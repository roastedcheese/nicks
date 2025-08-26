{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  imports = [
    ./nvidia.nix
    ./opengl.nix
  ];

  options.opt.hardware.displays = mkOption {
    type = types.attrsOf (
      types.submodule (_: {
        options = {
          width = mkOption {
            type = types.ints.u16;
          };
          height = mkOption {
            type = types.ints.u16;
          };
          refreshRate = mkOption {
            type = types.ints.u16;
          };
          scale = mkOption {
            type = types.oneOf [
              types.float
              (types.strMatching "^auto$")
            ];
            default = "auto";
          };
        };
      })
    );
    description = "Display information fed to the compositor";
    example = {
      "" = "1920x1080@60";
    };
  };
}
