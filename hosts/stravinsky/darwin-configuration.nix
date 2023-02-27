{ pkgs, nix, nixpkgs, config, lib, ... }:
let 
  me = "rick";
in
{
  imports = [<home-manager/nix-darwin>];
  environment.systemPackages = with pkgs; [
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
  nixpkgs.config.allwUnfree = true;

  programs.zsh.enable = true;
  programs.nushell.enable = true;
  programs.fish.enable = true;

  system.stateVersion = 4;

  nix = {
    nixPath = lib.mkForce [
      "nixpkgs=${nixpkgs}"
    ];
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
      (pkgs.nerdfonts.override { fonts = ["FiraCode" "Hack" "CascadiaCode"];})
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
      "yabai"
      "skhd"
      "handbrake"
    ];
    taps = [
      "koekeishiya/formulae"
    ];
    casks = [
      "hammerspoon"
      "firefox"
      "handbrake"
      "musescore"
      "steam"
      "neovide"
      "thunderbird"
      "krita"
      "gimp"
      "vlc"
      "kitty"
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
    ];
  };

  system.activationScripts.applications.text = pkgs.lib.mkForce ''
  echo "setting up ~/Applications/NixApps.."
  mkdir -p ~/Applications
  rm -rf ~/Applications/NixApps
  chown ${me} ~/Applications/NixApps
  find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read f; do
    echo "Linking $f"
    src=$(/usr/bin/statc -f%Y "$f")
    /usr/bin/osascript -e "tell app \"Finder\" to make alias file at POSIX file \"/Users/${me}/Applications/NixApps/\" to POSIX file \"$src\"";
  done
  '';

  home-manager.users.rick = import ./home.nix;

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
   
}
