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
      gibo
      direnv
      nix-direnv
      redis
      ngrok
      gh
      bacon
      cargo-expand
      microserver
      git-lfs
      nodejs
      nodePackages.pnpm
      nodePackages.typescript
      nodePackages.stylelint
      cargo-watch
      proselint
      backblaze-b2
      poetry
      mypy
      bun

      # languages
      elixir

      # music
      audacity

      # rust replacements
      tokei
      atuin

      # communication

      # misc
      sccache
      jq

      # random
      montserrat
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
