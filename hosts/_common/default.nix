{ config, pkgs, nixpkgs, lib, devenv, unstablePkgs, ... }:
{
  imports = [
    ./minimal.nix
    ../../programs/direnv/default.nix
    ../../programs/tmux.nix
    ../../programs/atuin.nix
  ];

  home = {
    sessionPath = [
      "${config.home.homeDirectory}/go/bin"
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.config/composer/vendor/bin"
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
      # ngrok
      gh
      bacon
      cargo-expand
      microserver
      git-lfs
      nodejs
      nodePackages.pnpm
      nodePackages.typescript
      cargo-watch
      proselint
      backblaze-b2
      poetry
      mypy
      unstablePkgs.bun
      devenv.packages.${pkgs.system}.devenv
      ocamlformat

      # languages
      elixir
      php
      ocaml

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

  };


  #nixpkgs.config.allowUnfree = true;

}
