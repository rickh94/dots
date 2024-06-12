{ config
, lib
, pkgs
, inputs
, ...
}: {
  imports = [
    ../../programs/neovim/basic.nix
    ../../programs/git.nix
    ../../programs/starship.nix
    ../../programs/tmux.nix
    ../../programs/bat.nix
    ../../programs/fish.nix
  ];
  home.username = "daveyjones";
  home.homeDirectory = "/home/daveyjones";

  programs.bash = {
    bashrcExtra = ''
      source /etc/profile.d/nix-env.sh
    '';
  };

  programs.zsh.profileExtra = ''
    source /etc/profile.d/nix-env.sh
  '';

  programs.fish.shellInit = ''
    source /etc/profile.d/nix-env.sh
  '';

  xsession.profileExtra = ''
    source /etc/profile.d/nix-env.sh
  '';

  xdg.enable = true;

  systemd.user.startServices = true;

  home = {
    stateVersion = "22.11";
    sessionVariables = {
      EDITOR = "nvim";
      MAKEFLAGS = "-j4";
      NIXPKGS_ALLOW_UNFREE = 1;
    };

    shellAliases = { };

    packages = with pkgs; [
      # basics
      wget
      tree
      # neovim
      zoxide
      fish
      mosh
      zip
      unzip
      htop
      zstd
      pass
      bash
      zsh
      pv
      netcat
      git-crypt
      gnupg

      # rust replacements
      difftastic
      tealdeer
      dogdns
      lfs
      starship
      carapace
      fzf
      ripgrep-all
      ripgrep
      bottom
      eza
      fd
      du-dust
      bat
      duf

      # basics
      ffmpeg
      kitty
      tmux
      killall
      backblaze-b2

      atuin

      sccache
      jq

      # random
      montserrat

      imagemagick
      smartmontools
    ];
  };

  programs.bash.enable = true;
  programs.zsh.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
