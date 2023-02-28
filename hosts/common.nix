{ config, pkgs, nixpkgs, lib, ... }:
{
  imports = [
    ../programs/direnv/default.nix
    ../programs/neovim.nix
    ../programs/nushell/default.nix
    ../programs/alacritty.nix
    ../programs/git.nix
    ../programs/kitty.nix
    ../programs/starship.nix
    ../programs/tmux.nix
    ../programs/zellij.nix
  ];

  home = {
    stateVersion = "22.11";
    sessionPath = [
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.local/bin"
    ];

    shellAliases = {
      hm = "home-manager";
      g = "git";
      cat = "bat";
      diff = "difftastic";
      du = "dust";
    };

    sessionVariables = {
      EDITOR = "nvim";
      MAKEFLAGS = "-j4";
      NIXPKGS_ALLOW_UNFREE = 1;
    };

    packages = with pkgs; [
    # basics
      alacritty
      ffmpeg
      wget
      tree
      kitty
      neovim
      nushell
      fish
      tmux
      mosh
      zip
      unzip
      htop
      killall
      zstd
      zoxide
      pass
      bash
      zsh
      pv
      netcat

    # dev tools
      neovide
      gibo
      direnv
      nix-direnv
      redis
      vscodium
      ngrok
      gh
      bacon
      gitui
      cargo-expand

    # languages
      (python310Full.withPackages (ps: with ps; [ pip flake8 black requests django ]))
      elixir
      go
      nodejs
      rustup

    # music
      audacity

    # rust replacements
      difftastic
      tldr
      dog
      lfs
      starship
      zellij
      carapace
      fzf
      ripgrep-all
      ripgrep
      bottom
      fd
      exa
      helix
      uutils-coreutils
      du-dust
      bat
      tokei

    # communication
      zoom-us

    # misc
      ncspot
      sccache
      wiki-tui
      obsidian
    ];
  };

  #nixpkgs.config.allowUnfree = true;

  programs.fish = {
    enable = true;
    /* interactiveShellInit = ''
      fish_add_path $HOME/.cargo/bin
      fish_add_path $HOME/.local/bin
      set -gx EDITOR nvim
      ''; */
  };
  programs.bash.enable = true;
  programs.zsh.enable = true;
}
