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

    functions = {
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
      title = "zellij action rename-tab $argv[1]";
    };
  };

}
