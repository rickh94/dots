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

      # languages
      (python310.withPackages (ps: with ps; [ pip flake8 black requests django ]))
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
  };

  #nixpkgs.config.allowUnfree = true;

}
