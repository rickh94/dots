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

  programs.home-manager.enable = true;

  home = {
    stateVersion = "22.11";
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
      firefox
      alacritty
      neovim
      neovide
      nerdfonts
      nushell
      fish
      starship
      zellij
      tmux
      carapace
      python310Full
      thunderbird
      gibo
      elixir
      go
      zip
      unzip
      nil
      glibc
      gnumake
      gcc12
      fzf
      htop
      killall
      ripgrep-all
      bottom
      nodejs
      rustup
      gimp
      krita
      vlc
      ranger
      zstd
      direnv
      nix-direnv
      redis
      vscode
      kitty
      brave
      ungoogled-chromium
      fd
      exa
      ngrok
      zoxide
      gh
      helix
      prismlauncher
      spotify
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
    ];
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
      package = pkgs.nix;
      settings.experimental-features = ["nix-command" "flakes"];
  };

  programs.fish.enable = true;
}
