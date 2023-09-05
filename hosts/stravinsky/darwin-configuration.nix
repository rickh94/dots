{ pkgs, nix, config, lib, chosenfonts, ... }:
let
  me = "rick";
in
{
  imports = [
    ../_common/mac/system-activation.nix
  ];
  environment.systemPackages = with pkgs; [
    redis
    colima
    docker
    home-manager
    neovim
    zsh
    alacritty
    git
    curl
    coreutils
    nushell
    nodejs
    python310Full
    fswatch
    rubik
  ];

  environment.systemPath = [
    "/opt/homebrew/bin/"
  ];

  services.nix-daemon.enable = true;

  programs.zsh.enable = true;
  programs.fish.enable = true;

  system.stateVersion = 4;

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };


  users = {
    users.rick = {
      home = /Users/rick;
      name = "rick";
    };
  };

  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override { fonts = chosenfonts; })
    ];
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    brews = [
      "macos-trash"
      "yabai"
      "skhd"
      "handbrake"
      "libiconv"
      "nss"
      # "oci-cli"
      "lilypond"
      "jq"
      "switchaudio-osx"
      "mongodb-community"
      "mongodb-database-tools"
      "brotli"
      "c-ares"
      "libnghttp2"
      "node@16"
      "libuv"
      "mongosh"
      "turso"
      "flyctl"
      "aom"
      "vercel-cli"
      "docker-credential-helper"
      # "dnsmasq"
      # "nginx"
      # "php"
    ];
    taps = [
      "FelixKratz/formulae"
      "koekeishiya/formulae"
      "homebrew/cask-versions"
      "homebrew/services"
      "chiselstrike/tap"
      "mongodb/brew"
    ];
    casks = [
      "sf-symbols"
      "firefox"
      "handbrake"
      "musescore"
      "steam"
      "gimp"
      "vlc"
      "brave-browser"
      "eloston-chromium"
      "prismlauncher"
      "spotify"
      "obs"
      "arq"
      "karabiner-elements"
      "nextcloud"
      "inkscape"
      "temurin8"
      "opera"
    ];
  };


  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  services.redis = {
    enable = true;
    bind = "127.0.0.1";
    port = 6379;
    package = pkgs.redis;
    dataDir = "/Users/rick/.local/state/redis";
  };

  services.dnsmasq = {
    enable = true;
    addresses = {
      "localhost" = "127.0.0.1";
    };
  };

  system.activationScripts.extraActivation.text = ''
        #!/usr/bin/env bash
        # PAM settings
        echo >&2 "setting up pam..."
    # Enable sudo Touch ID authentication
    # script from https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050
        if ! grep 'pam_tid.so' /etc/pam.d/sudo > /dev/null; then
          sed -i "" '2i\
        auth       sufficient     pam_tid.so
          ' /etc/pam.d/sudo
        fi
  '';

}
