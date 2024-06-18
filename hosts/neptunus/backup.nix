{ inputs, config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.sshfs ];
  fileSystems.mail = {
    device = "root@roastedcheese.org:/var/mail/";
    mountPoint = "/mnt/mail";
    fsType = "fuse.sshfs";
    options = [ "x-systemd.automount" "_netdev" "users" "idmap=user" "IdentityFile=/home/nick/.ssh/mercurius" "allow_other" "reconnect" "port=4545" ];
  };

  services.borgbackup.jobs = {
    mailbak = {
      paths = "/mnt/mail";
      repo = "/var/backup/mail";
      doInit = true;
      encryption = {
        mode = "repokey";
        passCommand = "cat ${config.age.secrets.mail_backup.path}";
      };
      compression = "auto,lzma";
      startAt = "daily";
    };
  };
}
