{ config, pkgs, lib, nixpkgs, ... }:

{
  imports =
    [
      ../_common/linux/configuration/basic.nix
      ../_common/linux/configuration/users-rick.nix
      ../_common/rick-passwordless-sudo.nix
      ./hardware-configuration.nix
    ];


  networking.hostName = "nixmc";
  networking.hostId = "d4e76b12";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = false;
    desktopManager.xfce.enable = true;
    layout = "us";
    xkbVariant = "";
  };


  environment.systemPackages = with pkgs; [
    # essentials
    neovim
    git

    killall


    fish
    wireguard-tools
    tree
    curl

    unzip
    zip
    openssl
  ];


  services =
    {
      minecraft-server = {
        package = pkgs.minecraft-server;
        declarative = true;
        eula = true;
        jvmOpts = "-Xms4096M -Xmx4096M -XX:+UseG1GC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
        whitelist = {
          rickhenry94 = "cacecf4a-70d5-43ff-8cba-01cc95a856dc";
        };
        serverProperties = {
          server-port = 43000;
          difficulty = 3;
          gamemode = 1;
          max-players = 5;
          motd = "Nixos MC Server";
          white-list = true;
        };
      };
    };


}

