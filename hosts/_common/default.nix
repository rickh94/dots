{ config
, pkgs
, nixpkgs
, lib
, devenv
, unstablePkgs
, ...
}: {
  imports = [
    ./minimal.nix
    ../../programs/direnv/default.nix
    ../../programs/tmux.nix
    ../../programs/atuin.nix
    # ../../programs/hishtory.nix
    ../../programs/sqlite.nix
  ];
  programs.thefuck.enable = true;

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
      unstablePkgs.atlas
      # ngrok
      gh
      unstablePkgs.bacon
      cargo-expand
      microserver
      git-lfs
      nodejs
      nodePackages.pnpm
      nodePackages.typescript
      cargo-watch
      proselint
      backblaze-b2
      # unstablePkgs.poetry
      mypy
      unstablePkgs.bun
      devenv.packages.${pkgs.system}.devenv
      ocamlformat

      # languages
      elixir
      php
      ocaml
      pypy3

      # music
      audacity

      # rust replacements
      tokei
      atuin
      # hishtory
      dfrs
      procs

      # communication

      # misc
      sccache
      jq

      # random
      montserrat

      imagemagick
      smartmontools
      viu

      # audio
      flac
      sox
      # unstablePkgs.openscad-unstable
    ];
  };

  #nixpkgs.config.allowUnfree = true;
}
