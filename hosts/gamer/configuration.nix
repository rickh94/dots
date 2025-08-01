{ config
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../_common/linux/configuration/boot.nix
    ../_common/linux/configuration/basic.nix
    ../_common/linux/configuration/podman.nix
    ../_common/linux/configuration/impermanence.nix
    ../_common/linux/configuration/users-rick.nix
  ];
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  # options nvidia_modeset vblank_sem_control=0

  networking.hostName = "nixgamer";
  networking.hostId = "a531a972";
  users.users.rick.shell = pkgs.zsh;

  services = {
    desktopManager.plasma6.enable = true;

    displayManager.sddm.enable = true;

    displayManager.sddm.wayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    firefox
    neovim
    git
    ghostty
    killall
    wireguard-tools
    tree
    podman
    podman-compose
    zsh
    ntfsprogs

    # kde plasma apps
    kdePackages.discover # Optional: Install if you use Flatpak or fwupd firmware update sevice
    kdePackages.kcalc # Calculator
    kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
    kdePackages.kcolorchooser # A small utility to select a color
    kdePackages.kolourpaint # Easy-to-use paint program
    kdePackages.ksystemlog # KDE SystemLog Application
    kdePackages.sddm-kcm # Configuration module for SDDM
    kdiff3 # Compares and merges 2 or 3 files or directories
    hardinfo2 # System information and benchmarks for Linux systems
    haruna # Open source video player built with Qt/QML and libmpv
    wayland-utils # Wayland utilities
    wl-clipboard # Command-line copy/paste utilities for Wayland

    # gaming
    wine
    winetricks
    lutris

    opencomposite

    distrobox

    rar
    unrar
    ffmpeg-full
    discord
    mumble
    nvidia-vaapi-driver
    usbutils
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration # Comment out this line if you use KDE Connect
    kdepim-runtime # Unneeded if you use Thunderbird, etc.
    konsole # Comment out this line if you use KDE's default terminal app
    oxygen
  ];

  programs.zsh.enable = true;

  environment.pathsToLink = [ "/libexec" ];
  services.atd.enable = true;
  nix.optimise.automatic = true;
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    platformOptimizations.enable = true;
  };
  programs.gamescope.enable = true;
  programs.java.enable = true;

  services.pipewire.lowLatency.enable = true;

  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
    packages = [
      "flathub:app/app.zen_browser.zen//stable"
      "flathub:app/org.prismlauncher.PrismLauncher//stable"
      #"flathub:app/io.github.wivrn.wivrn//stable"
      "flathub:app/com.obsproject.Studio//stable"
    ];
  };

  services.sanoid = {
    enable = true;
    datasets = {
      "rpool/safe" = {
        yearly = 0;
        hourly = 12;
        daily = 7;
        weekly = 4;
        monthly = 6;
        recursive = true;
        autosnap = true;
        autoprune = true;
      };
    };
  };
  system.stateVersion = "25.05";

  # networking.wg-quick.interfaces = {
  #   wg0 = {
  #     address = [ "10.7.0.105/24" ];
  #     listenPort = 51820;
  #     mtu = 1410;
  #     privateKeyFile = "/persist/secrets/wireguard/privkey";
  #     # dns = [
  #     #   "10.7.0.100"
  #     #   "127.0.0.1"
  #     # ];
  #     peers = [
  #       {
  #         # albanberg
  #         publicKey = "t9S4OAhiK5ZMmNdYsLEBj/fas9DyG5B61v1c59VBpQw=";
  #         endpoint = "10.0.1.100:51820";
  #         allowedIPs = [ "10.7.0.100/32" ];
  #         presharedKeyFile = "/persist/secrets/wireguard/berg-psk";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };

  services.avahi.publish.userServices = true;
  services.avahi.publish.enable = true;
  services.avahi.ipv6 = true;

  networking.firewall = {
    enable = false;
  };

  services.zfs.autoSnapshot.enable = false;
  services.zfs.autoScrub.enable = true;
  services.zfs.trim = {
    enable = true;
    interval = "weekly";
  };

  security.polkit.enable = true;
  programs.obs-studio.enable = true;
}
