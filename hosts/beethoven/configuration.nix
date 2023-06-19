{ config, pkgs, lib, chosenfonts, inputs, ... }:

let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
  unstable = import inputs.unstable {
    system = pkgs.system;
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
      "${impermanence}/nixos.nix"
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
  boot.tmp.tmpfsSize = "8G";
  boot.kernelParams = [ "nohibernate" ];


  networking.hostName = "beethoven";
  networking.hostId = "85462731";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        enable = true;
        greeters.slick.enable = true;
      };
    };
    windowManager.bspwm.enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
    desktopManager.xfce.enable = true;
    layout = "us";
    xkbVariant = "";
  };


  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  # local network peer dns resolution
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      workstation = true;
      hinfo = true;
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true;
      swtpm.enable = true;
    };
  };

  virtualisation.oci-containers.backend = "podman";

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    extraPackages = [
      pkgs.zfs
    ];
  };

  virtualisation.containers.storage.settings = {
    storage = {
      driver = "zfs";
      graphroot = "/var/lib/containers/storage";
      runroot = "/run/containers/storage";
    };
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.rick = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ]; # Enable ‘sudo’ for the user.
    passwordFile = "/persist/passwd/rick";
  };

  environment.systemPackages = with pkgs; [
    firefox
    (nerdfonts.override { fonts = chosenfonts; })
    neovim
    git
    alacritty
    sxhkd
    xorg.xinit
    killall
    xdotool
    xorg.xwininfo
    lightdm-slick-greeter
    nushell
    wireguard-tools
    tree
    curl
    pavucontrol
    podman
    podman-compose
    qemu_full
    nextcloud-client
  ];

  environment.pathsToLink = [ "/libexec" ];
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.extraOptions = ''
    min-free = ${toString (100 * 1024 * 1024)}
    max-free = ${toString (1024 * 1024 * 1024)}
  '';

  nixpkgs.config.allowUnfree = true;

  services.zfs.trim.enable = true;

  # WIPE ROOT CONFIGURATION
  environment.persistence."/persist/impermanence" = {
    directories = [
      "/etc/nixos"
      "/var/lib/containers/storage"
      "/opt/syncoid"
    ];
    files = [
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/machine-id"
    ];
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r nvme/local/root@blank
  '';

  fileSystems."/persist".neededForBoot = true;


  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.config = lib.mkAfter ''
    Section "InputClass"
    Identifier "MX Master Acceleration"
    MatchDriver "libinput"
    MatchProduct "MX Master"
    Option "AccelSpeed" "-0.6"
    EndSection
  '';
  services.xserver.screenSection = ''
    Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
  '';
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;

  services.redis.servers.default.enable = true;
  services.redis.servers.default.port = 6379;

  services.sanoid = {
    enable = true;
    datasets = {
      "nvme/safe" = {
          recursive = true;
          autosnap = true;
          autoprune = true;
      };
    };
  };

  services.syncoid = {
      enable = true;
      sshKey = "/opt/syncoid/id_ed25519";
      interval = "daily";
      commands."chopin" = {
          source = "nvme/safe";
          target = "beethoven@chopin:backuptank/beethoven/nvme/safe";
          recursive = true;
          extraArgs = [ "--sshoption=StrictHostKeyChecking=off"];
        };
    };

  security.sudo.extraRules = [
    { users = ["syncoid" "sanoid"]; commands = [{ command = "${pkgs.zfs}/bin/zfs"; options = ["NOPASSWD"]; }];}
  ];
}

