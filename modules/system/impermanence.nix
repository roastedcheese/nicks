{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkOption mkEnableOption optionals types mkIf;
  cfg = config.opt.system.impermanence;
in {
  imports = [inputs.impermanence.nixosModule];

  options.opt.system.impermanence = {
    enable = mkEnableOption "the system impermanence module";
    root = {
      device = mkOption {
        type = types.str;
        description = "Path to unencrypted btrfs filesystem";
        example = "/dev/sda2";
      };

      subvolume = mkOption {
        type = types.str;
        description = "Root subvolume name";
        example = "root";
      };

      expiration = mkOption {
        type = types.ints.u16;
        description = "time in days to delete old roots after";
        default = 7;
      };
    };

    persistent = mkOption {
      type = types.str;
      description = "Persistent subvolume mountpoint";
      example = "persist";
    };

    directories = mkOption {
      type = with types; nullOr (listOf (oneOf [str attrs]));
      description = "directories to bind mount to persistent storage";
      example = [
        "/var/log"
        "/var/lib/nixos"
        {
          directory = "/var/lib/colord";
          user = "colord";
          group = "colord";
          mode = "u=rwx,g=rx,o=";
        }
      ];
      default = null;
    };

    files = mkOption {
      type = with types; nullOr (listOf (oneOf [str attrs]));
      description = "files to link or bind to persistent storage";
      example = [
        "/etc/machine-id"
        {
          file = "/var/keys/secret_file";
          parentDirectory = {mode = "u=rwx,g=,o=";};
        }
      ];
      default = null;
    };
  };

  config = mkIf cfg.enable {
    # Wipe root subvolume on boot
    boot.initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount ${cfg.root.device} /btrfs_tmp
      if [[ -e /btrfs_tmp/${cfg.root.subvolume} ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/${cfg.root.subvolume} "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +${builtins.toString cfg.root.expiration}); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/${cfg.root.subvolume}
      umount /btrfs_tmp
    '';

    environment.persistence.${cfg.persistent} = {
      hideMounts = true;
      directories =
        (optionals (cfg.directories != null) cfg.directories)
        ++ [
          "/var/log"
          "/var/lib/nixos"
          "/etc/ssh"
          "/var/lib/systemd/coredump"
          "/mnt"
        ];
      files =
        (optionals (cfg.files != null) cfg.files)
        ++ [
          "/etc/machine-id"
        ];
    };
  };
}
