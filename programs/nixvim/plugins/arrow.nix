{ ...
}: {
  programs.nixvim.plugins.arrow = {
    enable = true;
    settings = {
      show_icons = true;
      leader_key = ";";
      buffer_leader_key = "m";
    };
  };
}
