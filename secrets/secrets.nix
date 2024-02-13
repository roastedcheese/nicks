let
  mercurius = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkTtLr4JCeCBcWc78r1H0xUezWgDhwBbnmvPPY2Je/x";
in {
  "mailserver.age".publicKeys = [ mercurius ];
}
