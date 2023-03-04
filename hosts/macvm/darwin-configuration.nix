{ pkgs, nix, config, lib, ... }:
{
  imports = [
    ../_common/mac/system-activation.nix
  ];

  environment.systemPackages = with pkgs; [
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
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" "Hack" "CascadiaCode" "VictorMono"]; })
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
    ];
    taps = [
      "koekeishiya/formulae"
    ];
    casks = [
      "firefox"
      "iterm2"
      "brave-browser"
      "eloston-chromium"
      "bitwarden"
    ];
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;


}
