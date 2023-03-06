{ pkgs, nix, config, lib, nerdfonts, ... }:
let
  me = "rick";
in
{
  imports = [
    ../_common/mac/system-activation.nix
  ];
  environment.systemPackages = with pkgs; [
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
      (pkgs.nerdfonts.override { fonts = nerdfonts; })
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
      # "buffalo"
      # "buffalo-pop"
    ];
    taps = [
      "koekeishiya/formulae"
      # "gobuffalo/tap"
    ];
    casks = [
      "firefox"
      "handbrake"
      "musescore"
      "steam"
      "thunderbird-beta"
      "iterm2"
      "krita"
      "gimp"
      "vlc"
      "brave-browser"
      "eloston-chromium"
      "prismlauncher"
      "spotify"
      "bitwarden"
      "obs"
      "arq"
      "rancher"
      "plex-htpc"
      "plexamp"
      "syncthing"
      "karabiner-elements"
    ];
  };


  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;


}
