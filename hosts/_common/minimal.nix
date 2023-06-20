{ config, pkgs, nixpkgs, lib, ... }:
{
  imports = [
    ../../programs/neovim.nix
    ../../programs/nushell/default.nix
    ../../programs/git.nix
    ../../programs/starship.nix
    ../../programs/zellij.nix
    ../../programs/bat.nix
    ../../programs/fish.nix
  ];

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

      # languages
      go
      nodejs
      rustup
      (python310.withPackages (ps: with ps; [ pip flake8 black requests django ]))

      # rust replacements
      difftastic
      tealdeer
      dogdns
      lfs
      starship
      zellij
      carapace
      fzf
      ripgrep-all
      ripgrep
      bottom
      exa
      fd
      uutils-coreutils
      du-dust
      bat
    ];

  };

  programs.bash.enable = true;
  programs.zsh.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

}
