{ config, pkgs, nixpkgs, lib, ... }:
{
  imports = [
    ./minimal.nix
    ../../programs/direnv/default.nix
    ../../programs/alacritty.nix
    ../../programs/kitty.nix
    ../../programs/tmux.nix
  ];

  home = {
    stateVersion = "22.11";
    sessionPath = [
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.local/bin"
    ];



    packages = with pkgs; [
      # basics
      alacritty
      ffmpeg
      kitty
      tmux
      killall

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
      rust-analyzer

      # languages
      elixir

      # music
      audacity

      # rust replacements
      helix
      tokei

      # communication
      zoom-us

      # misc
      ncspot
      sccache
      wiki-tui
      obsidian
    ];

    file."Wallpapers/wallpapers.txt" = {
      enable = true;
      source = ../../wallpapers/wallpapers.txt;
      onChange = ''
        #!/usr/bin/env bash
        cd $HOME/Wallpapers
        ${pkgs.wget}/bin/wget -v -i wallpapers.txt
      '';
    };
  };

  #nixpkgs.config.allowUnfree = true;

}