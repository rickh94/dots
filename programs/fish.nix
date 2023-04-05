{ ... }:
{

  programs.fish = {
    enable = true;
    shellAliases = {
      hm = "home-manager";
      g = "git";
      diff = "difft";
      du = "dust";
      ls = "exa";
      cat = "bat";
      df = "lfs";
      grep = "rg";
      find = "fd";
      mkdir = "mkdir -p";
    };

    functions = {
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
      title = "zellij action rename-tab $argv[1]";
      getlinuxformat = "wget https://raw.githubusercontent.com/torvalds/linux/master/.clang-format";
    };
  };

}
