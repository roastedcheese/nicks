{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkPackageOption mkEnableOption mkOption types mkIf;
  cfg = config.opt.services.minecraft;
in {
  options.opt.services.minecraft = {
    enable = mkEnableOption "minecraft sever";
    package = mkPackageOption pkgs "minecraft-server" {example = "minecraft-server";};
    jvmOpts = mkOption {
      type = types.separatedString " ";
      default = "-Xmx2048M -Xms2048M";
      description = "JVM options for the Minecraft server.";
    };
  };

  config.services.minecraft-server = mkIf cfg.enable {
    eula = true;
    enable = true;
    inherit (cfg) package;
    inherit (cfg) jvmOpts;
    openFirewall = true;
  };
}
