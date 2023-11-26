{ ... }: {
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
    interactiveShellInit =
      /*
      fish
      */
      ''
        fish_vi_key_bindings
      '';

    functions = {
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
      getlinuxformat = "wget https://raw.githubusercontent.com/torvalds/linux/master/.clang-format";
      /*
      vm-nvim = ''
        set hash (openssl rand -hex 4)
        echo /tmp/$hash
        if [ (which pbcopy) ]
          echo /tmp/$hash |pbcopy
        end
        if [ (which xclip) ]
          echo /tmp/$hash |xclip
        end
        ssh -t -L /tmp/$hash:/tmp/$hash rick@10.7.0.100 "ssh -t -L /tmp/$hash:/tmp/$hash rick@nixx86-vm \'nvim --headless --listen /tmp/$hash\'"
      '';
      nvimremote = ''
        set hash (openssl rand -hex 4)
        if [ (which pbcopy) ]
          echo /tmp/$hash |pbcopy
        end
        if [ (which xclip) ]
          echo /tmp/$hash |xclip
        end
        ssh -t -L /tmp/$hash:/tmp/$hash \$\{argv[1]\} "nvim --headless --listen /tmp/$hash"
      '';
      */
    };
  };
}
