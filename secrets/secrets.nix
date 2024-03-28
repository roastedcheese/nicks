let
  mercurius = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkTtLr4JCeCBcWc78r1H0xUezWgDhwBbnmvPPY2Je/x";
in {
  "mailserver.age".publicKeys = [ mercurius ];
  "mailserver_matrix.age".publicKeys = [ mercurius ];
  "matrix_mail.age".publicKeys = [ mercurius ];
  "matrix_secret.age".publicKeys = [ mercurius ];
  "znc_admin.age".publicKeys = [ mercurius ];
  "znc_user.age".publicKeys = [ mercurius ];
}
