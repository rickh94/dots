{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    shellAliases = {
      hm = "home-manager";
      g = "git";
      diff = "difft";
      du = "dust";
      ls = "eza";
      cat = "bat";
      grep = "rg";
      find = "fd";
      mkdir = "mkdir -p";
    };

    plugins = [
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "foreign-env";
        src = pkgs.fishPlugins.foreign-env.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "fzf.fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];

    shellInit = ''
      # nix
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end

      # home-manager
      if test -e /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh
          fenv source /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh
      end
      # home-manager
      if test -e $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
          fenv source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      end
    '';

    interactiveShellInit =
      /*
      fish
      */
      ''
        fish_vi_key_bindings
        if test -e $HOME/.hishtory/config.fish
          fzf_configure_bindings --history=
          source $HOME/.hishtory/config.fish
          bind -M insert \cr __hishtory_on_control_r
        end
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
