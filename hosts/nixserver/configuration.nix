{ config, pkgs, lib, nixpkgs, ... }:

let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in
{
  imports =
    [
      ../_common/linux/configuration/boot.nix
      ../_common/linux/configuration/basic.nix
      ../_common/linux/configuration/virt.nix
      ../_common/linux/configuration/users-rick.nix
      ./hardware-configuration.nix
      "${impermanence}/nixos.nix"
    ];


  networking.hostName = "berg";
  networking.hostId = "d4e76b17";
  networking.nat.internalInterfaces = [ "wg0" ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    layout = "us";
    xkbVariant = "";
  };


  environment.systemPackages = with pkgs; [
    # essentials
    firefox
    neovim
    git

    alacritty
    xorg.xinit
    killall
    xdotool
    xorg.xwininfo

    home-manager

    fish
    wireguard-tools
    tree
    curl

    virt-manager
    virt-viewer

    unzip
    zip

  ];

  services = {
    ddclient = {
      enable = true;
      use = "web, web=dynamicdns.park-your-domain.com/get-ip";
      protocol = "namecheap";
      ipv6 = false;
      server = "dynamicdns.park-your-domain.com";
      passwordFile = "/persist/secrets/ddclient";
      domains = [
        "vpn"
      ];
      extraConfig = ''
        login=rickhenry.house
      '';
    };

    home-assistant = {
      enable = true;
      config = {
        default_config = { };
      };
    };

    mosquitto = {
      enable = true;
      persistence = true;
      listeners = [
        {
          port = 1883;
          users = {
            blacklamp.hashedPasswordFile = "/persist/passwd/mosquitto/blacklamp";
            silverlamp.hashedPasswordFile = "/persist/passwd/mosquitto/silverlamp";
            desklight.hashedPasswordFile = "/persist/passwd/mosquitto/desklight";
          };
        }
      ];
    };

    jellyfin.enable = true;

    nextcloud = {
      enable = true;
      package = pkgs.nextcloud27;
      hostName = "localhost";
      config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
      # extraApps = with config.services.nextcloud.package.packages.apps; {
      #   inherit news contacts calendar tasks;
      # };
      extraAppsEnable = true;
      configureRedis = true;
      extraOptions = {
        mail_smtpmode = "sendmail";
        mail_sendmailmode = "pipe";
      };
      secretFile = "/etc/nextcloud-secrets.json";
      phpOptions = {
        upload_max_filesize = "16G";
        post_max_size = "16G";
      };
    };

    nginx.virtualHosts."localhost".listen = [{ addr = "127.0.0.1"; port = 8080; }];

    sanoid = {
      enable = true;
      datasets = {
        "rpool/safe" = {
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "tank/media" = {
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "tank/nextcloud" = {
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
      };
    };

    # restic.backups.myaccount = {
    #   initialize = true;
    #   passwordFile = "/persist/secrets/restic";
    #   paths = [
    #     "/home/rick"
    #     "/tank/media"
    #     "/tank/nextcloud"
    #   ];
    #
    #   repository = "b2:thing";
    #   timerConfig = {
    #     OnUnitActiveSec = "1d";
    #   };
    #
    #   pruneOpts = [
    #     "--keep-daily=7"
    #     "--keep-weekly=4"
    #     "--keep-monthly=2"
    #     "--keep-yearly=0"
    #   ];
    # };

    samba = {
      openFirewall = true;
      enable = true;
      securityType = "user";
      extraConfig = ''
        workgroup = WORKGROUP
        server string = smbnix
        netbios name = smbnix
        security = user 
        #use sendfile = yes
        #max protocol = smb2
        # note: localhost is the ipv6 localhost ::1
        hosts allow = 10.0.0. 10.7.0. 127.0.0.1 localhost
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
      '';

      shares = {
        rick = {
          path = "/srv/rick";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "rick";
          "force group" = "users";
          "valid users" = "rick";
        };
      };
    };

    vaultwarden = {
      enable = true;
      backupDir = "/tank/vw-backups";
      config = {
        DOMAIN = "https://vw2.rickhenry.house";
        SIGNUPS_ALLOWED = false;
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";
        # TODO: smtp config
      };
      environmentFile = "/persist/secrets/vaultwarden";
    };

    smartd = {
      enable = true;
      autodetect = true;
    };

    caddy = {
      enable = true;
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "rickhenry@rickhenry.dev";
    certs."rickhenry.house" = {
      domain = "*.rickhenry.house";
      dnsProvider = "namecheap";
      credentialsFile = "/persist/secrets/acme/namecheap";
      group = config.services.caddy.group;
    };
  };

  programs.msmtp = {
    enable = true;
    accounts.default = {
      auth = true;
      tls = true;
      from = "berg@mg.rickhenry.house";
      user = "berg@mg.rickhenry.house";
      passwordeval = "cat /persist/secrets/msmtp";
      host = "smtp.mailgun.org";
    };
  };

  systemd.services.restic-backups-myaccount = {
    #TODO: add env vars with secrets storage or secrets file
  };

  virtualisation.oci-containers.containers."audiobookshelf" = {
    autoStart = true;
    image = "ghcr.io/advplyr/audiobookshelf:latest";
    environment = {
      AUDIOBOOKSHELF_UID = "99";
      AUDIOBOOKSHELF_GID = "100";
    };

    ports = [ "13378:80" ];
    volumes = [
      "/tank/media/Audiobooks:/audiobooks"
      "/tank/media/Podcasts:/podcasts"
      "/tank/media/Containers/Audiobookshelf/config:/config"
      "/tank/media/Containers/Audiobookshelf/audiobooks:/metadata"
    ];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime
    ];
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.7.0.100/24" ];
      listenPort = 51820;
      privateKeyFile = "/persist/secrets/wireguard/privkey";
      peers = [
        {
          # stravinsky
          publicKey = "V530/oK8ToieScSB44I0ft6o8emHikOiSFfG0gH8+zE=";
          allowedIPs = [ "10.7.0.20/32" ];
          presharedKeyFile = "/persist/secrets/wireguard/stravinsky-psk";
          persistentKeepalive = 25;
        }
        {
          # paganini
          publicKey = "7/O//IXIEpMoh51I23PKyomKdhS4ELkKQIiiY61dJx8=";
          allowedIPs = [ "10.7.0.30/32" ];
          presharedKeyFile = "/persist/secrets/wireguard/paganini-psk";
          persistentKeepalive = 25;
        }
      ];
    };
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 53 8123 8096 8222 5357 ];
    allowedUDPPorts = [ 53 5353 51820 5357 ];
    extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
    allowPing = true;
  };

  boot.zfs.extraPools = [ "tank" ];



  # WIPE ROOT CONFIGURATION
  environment.persistence."/persist/impermanence" = {
    directories = [
      "/etc/nixos"
      "/var/lib/acme"
    ];
    files = [
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/machine-id"
      "/etc/nextcloud-secrets.json"
    ];
  };

  environment.persistence."/tank/impermanence" = {
    directories = [
      "/var/lib/containers"
      { directory = "/var/lib/jellyfin"; user = "jellyfin"; }
      {
        directory = "/var/lib/nextcloud";
        user = "nextcloud";
      }
      {
        directory = "/var/lib/bitwarden_rs";
        user = "vaultwarden";
      }
      { directory = "/var/lib/hass"; user = "hass"; }
      { directory = "/var/lib/mosquitto"; user = "mosquitto"; }
      "/var/lib/samba"
    ];
  };

  boot.initrd.postDeviceCommands = lib.mkAfter
    ''
      zfs rollback -r rpool/local/root@blank
    '';

  fileSystems."/persist".neededForBoot = true;

  security.sudo.extraRules = [
    {
      users = [ "rick" ];
      commands = [{ command = "ALL"; options = [ "SETENV" "NOPASSWD" ]; }];
    }
  ];
  # TODO: additional samba shares

  nix.settings.sandbox = false;
}

