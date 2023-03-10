{ ... }:
{

  programs.fish = {
    enable = true;
    shellAliases = {
      hm = "home-manager";
      g = "git";
      diff = "difftastic";
      du = "dust";
      ls = "exa";
      cat = "bat";
      df = "lfs";
      grep = "rg";
      find = "fd";
    };

  };

}
