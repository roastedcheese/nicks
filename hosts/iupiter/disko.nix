{ inputs, config, ... }:
let
  user = config.opt.system.username;
in 
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
                    "/persist" = {
                      mountOptions = [ "subvol=persist" ];
                      mountpoint = "/persist";
                    };
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
    };
  };

  fileSystems."/persist".neededForBoot = true;

  environment.etc.crypttab.text = ''
    media /dev/disk/by-id/wwn-0x5000c500e324ad19-part2 /etc/media.key luks
  '';

  systemd.mounts = [
    {
      wantedBy = [ "multi-user.target" ];
      what = "/dev/mapper/media";
      where = "/home/${user}/Media";
      type = "ext4";
    }
  ];
}
