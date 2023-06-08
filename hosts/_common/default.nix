{ config, pkgs, nixpkgs, lib, ... }:
{
  imports = [
    ./minimal.nix
    ../../programs/direnv/default.nix
    ../../programs/alacritty.nix
    ../../programs/kitty.nix
    ../../programs/tmux.nix
    ../../programs/atuin.nix
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
      microserver
      git-lfs
      nodejs
      nodePackages.pnpm
      cargo-watch
      nodePackages.stylelint
      proselint
      backblaze-b2
      poetry

      # languages
      elixir

      # music
      audacity

      # rust replacements
      helix
      tokei
      atuin

      # communication
      zoom-us

      # misc
      ncspot
      sccache
      wiki-tui
      jq
      obsidian
    ];

    file."Wallpapers/wallpapers.txt" = {
      enable = true;
      source = ../../wallpapers/wallpapers.txt;
      onChange = ''
        #!/usr/bin/env bash
        cd $HOME/Wallpapers
        ${pkgs.wget}/bin/wget -nc -i wallpapers.txt
      '';
    };
  };


  #nixpkgs.config.allowUnfree = true;

}
