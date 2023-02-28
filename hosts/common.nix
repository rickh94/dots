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
    # TODO: this only works sometimes, just do it manually in shell configs
    sessionPath = [
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.local/bin"
    ];

    shellAliases = {
      hm = "home-manager";
      g = "git";
    };

    sessionVariables = {
      EDITOR = "nvim";
      MAKEFLAGS = "-j4";
    };

    packages = with pkgs; [
      ffmpeg
      audacity
      alacritty
      zoom-us
      neovim
      nushell
      fish
      starship
      zellij
      tmux
      carapace
      (python310Full.withPackages (ps: with ps; [ pip flake8 black requests django ]))
      mosh
      gibo
      elixir
      go
      zip
      unzip
      nil
      gnumake
      gcc12
      fzf
      htop
      killall
      ripgrep-all
      bottom
      nodejs
      rustup
      ranger
      zstd
      direnv
      nix-direnv
      redis
      vscodium
      fd
      exa
      ngrok
      zoxide
      gh
      helix
      pass
      rust-analyzer
      bash
      zsh
      uutils-coreutils
      pv
      du-dust
      bat
      bacon
      gitui
      ncspot
      openssl
      netcat
      sccache
      cargo-expand
      wiki-tui
      obsidian
      colima
      rancher
      docker
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  programs.bash.enable = true;
  programs.zsh.enable = true;
}
