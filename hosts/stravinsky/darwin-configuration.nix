{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.redis
    pkgs.colima
    pkgs.docker
    pkgs.home-manager
    pkgs.neovim
    pkgs.zsh
    pkgs.alacritty
    pkgs.git
    pkgs.curl
    pkgs.python313Full
  ];

  environment.systemPath = [
    "/opt/homebrew/bin/"
  ];

  programs.zsh.enable = true;
  programs.fish.enable = true;

  system.stateVersion = 4;
  system.primaryUser = "rick";

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 20d";
    };
    settings.trusted-users = [
      "rick"
      "root"
    ];
    optimise.automatic = true;
  };

  users = {
    users.rick = {
      home = /Users/rick;
      name = "rick";
    };
  };

  # fonts = {
  #   packages = [
  #     pkgs.libre-baskerville
  #     (pkgs.nerdfonts.override { fonts = chosenfonts; })
  #   ];
  # };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "none";
    };
    brews = [
      "libiconv"
      "nss"
      "lilypond"
      "jq"
      "switchaudio-osx"
      "brotli"
      "c-ares"
      "libnghttp2"
      "node@16"
      "libuv"
      "turso"
      "flyctl"
      "aom"
      "docker-credential-helper"
      "dos2unix"
      "mpv"
      "litestream"
      # {
      #   name = "supersonic-app/supersonic/supersonic";
      #   args = [ "no-quarantine" ];
      # }
      #     "avr-binutils"
      #"avrdude"
    ];
    taps = [
      "FelixKratz/formulae"
      "koekeishiya/formulae"
      "homebrew/services"
      "homebrew/cask-versions"
      "chiselstrike/tap"
      "mongodb/brew"
      "libsql/sqld"
      "benbjohnson/litestream"
      "osx-cross/avr"
      "supersonic-app/supersonic"
    ];
    casks = [
      "alt-tab"
      "proton-mail"
      "steam"
      "protonvpn"
      "proton-drive"
      "sf-symbols"
      "firefox"
      "handbrake"
      "musescore"
      "steam"
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
      # "temurin8"
      "opera"
      "iterm2"
      "wezterm"
      "arc"
      "intellij-idea-ce"
      "libreoffice"
      "canva"
      "mp3tag"
      "openzfs"
      "textual"
      "mediainfo"
      "mediahuman-audio-converter"
      "mediahuman-youtube-downloader"
      "iina"
      "zoom"
      "maccy"
      "discord"
      "zen-browser"
      "orcaslicer"
      "freecad"
      "tor-browser"
      "ghostty"
      "audacity"
      "alfred"
      "lapce"
    ];
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = false;

  # services.redis = {
  #   enable = true;
  #   bind = "127.0.0.1";
  #   port = 6379;
  #   package = pkgs.redis;
  #   dataDir = "/Users/rick/.local/state/redis";
  # };

  services.dnsmasq = {
    enable = false;
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
