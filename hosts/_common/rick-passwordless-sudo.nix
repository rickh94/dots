{ ... }: {

  security.sudo.extraRules = [
    {
      users = [ "rick" ];
      commands = [{ command = "ALL"; options = [ "SETENV" "NOPASSWD" ]; }];
    }
  ];
}
