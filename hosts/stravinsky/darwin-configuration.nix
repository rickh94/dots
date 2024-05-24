{ pkgs
, chosenfonts
, ...
}: {
  imports = [
    ../_common/mac/system-activation.nix
  ];
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
    pkgs.python311Full
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
    gc = {
      automatic = true;
      user = "rick";
    };
  };

  users = {
    users.rick = {
      home = /Users/rick;
      name = "rick";
    };
  };
  #
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
      cleanup = "none";
    };
    brews = [
      "macos-trash"
      "handbrake"
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
      "vercel-cli"
      "docker-credential-helper"
      "dos2unix"
    ];
    taps = [
      "FelixKratz/formulae"
      "koekeishiya/formulae"
      "homebrew/services"
      "homebrew/cask-versions"
      "chiselstrike/tap"
      "mongodb/brew"
      "libsql/sqld"
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
      "amethyst"
      "iterm2"
      "wezterm"
      "arc"
      "intellij-idea-ce"
      "libreoffice"
      "canva"
      "mp3tag"
      "openzfs"
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
