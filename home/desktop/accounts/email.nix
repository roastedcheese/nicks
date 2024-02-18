# Mostly copied from @notashelf's
{ pkgs, config, ... }:
let
  extraMailboxes = ["Archive" "Drafts" "Junk" "Sent" "Trash"];
in {
  accounts.email = {
    maildirBasePath = "${config.home.homeDirectory}/Mail";
    accounts = let
      default = { u ? "cheese", d ? "roastedcheese.org", n ? "RoastedCheese", g ? "B31F6D32812D476A330F25CBACFA5BAF88B22D43" }: {
        address = "${u}@${d}";
        username = "${u}@${d}";
        realname = n;

        folders = {
          inbox = "Inbox";
          drafts = "Drafts";
          sent = "Sent";
          trash = "Trash";
        };

        imap = {
          host = d;
          tls.enable = true;
        };

        smtp = {
          host = d;
          tls.enable = true;
        };

        gpg = {
          key = g;
          signByDefault = true;
        };

        msmtp.enable = true;
        mbsync = {
          enable = true;
          create = "maildir";
          expunge = "both";
        };
      };
      in {
        cheese = default {} // { primary = true; };
        bill = default { u  = "bill"; };
        noreply = default { u = "noreply"; };
      };
    };

    systemd.user = {
      timers."mbsync" = {
        Unit.Description = "Automatic mbsync synchronization";
        Timer = {
          OnBootSec = "30";
          OnUnitActiveSec = "5m";
        };
        Install.WantedBy = ["timers.target"];
      };

      services."genFolders" = {
        Unit.Description = "Generate folders for email accounts";
        Install.WantedBy = ["multi-user.target"];
        Service = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = let
            script = pkgs.writeShellApplication {
              name = "genFolders";
              text = ''
                # move to the current user's home directory
                # FIXME: pretty sure this can also be set as the service's runtime dir
                cd ${config.accounts.email.maildirBasePath}

                # iterate over dirs and create those that do not exist
                for dir in ${toString extraMailboxes}; do
                  if [ ! -d "$dir" ]; then
                    echo -en "$dir does not exist, creating...\n";
                    mkdir "$dir"
                    echo "Done creating $dir"
                  fi
                done
              '';
            };
          in "${script}/bin/genFolders";

          # set runtime dir to the current user's home directory
        };
      };
    };
}
