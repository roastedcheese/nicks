{ inputs, config, ... }:
{
  imports = [ inputs.disko.nixosModules.disko];

  disko.devices = {
    disk = {
      root = {
        type = "disk";
        device = "/dev/disk/by-id/eui.002538b12140c57d";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "1025M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };

            root = {
              size = "100%";
              content = {
                type = "luks";
                name = "root";

                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];

                  subvolumes = {
                    root.mountpoint = "/";
                    home = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" ];
                    };
                    nix = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                  };
                };
              };
            };
          };
        };
      };

      media = {
        type = "disk";
        device = "/dev/disk/by-id/0x5000c500e324ad19";
        content = {
          type = "gpt";
          partitions = {
            media = {
              size = "100%";
              content = {
                type = "luks";
                name = "media";
                settings.keyFile = "/etc/media.key";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/home/${config.opt.system.username}/Media";
                };
              };
            };
          };
        };
      };
    };
  };
}
