{ pkgs
, unstablePkgs
, ...
}: {
  imports = [
    ./minimal.nix
    ../../programs/direnv/default.nix
    ../../programs/tmux.nix
    ../../programs/atuin.nix
    ../../programs/sqlite.nix
  ];

  home = {
    packages = with pkgs; [
      # basics
      ffmpeg-full
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
      nodePackages.ts-node
      unstablePkgs.tsx
      cargo-watch
      proselint
      backblaze-b2
      # unstablePkgs.poetry
      unstablePkgs.mypy
      unstablePkgs.bun
      ocamlformat
      nodePackages.ts-node

      # languages
      elixir
      php
      ocaml
      #pypy3

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
      (python313.withPackages (ps: with ps; [ pip ]))

      # audio
      flac
      sox
      # unstablePkgs.openscad-unstable
    ];
  };

  #nixpkgs.config.allowUnfree = true;
}
