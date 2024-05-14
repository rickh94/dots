{ config
, pkgs
, lib
, ...
}:
let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in
{
  imports = [
    ../_common/linux/configuration/boot.nix
    ../_common/linux/configuration/basic.nix
    ../_common/linux/configuration/virt.nix
    ../_common/linux/configuration/users-rick.nix
    ../_common/rick-passwordless-sudo.nix
    ./hardware-configuration.nix
    "${impermanence}/nixos.nix"
  ];

  users.users.rick.shell = pkgs.zsh;
  programs.zsh.enable = true;

  networking.hostName = "albanberg";
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
    restic

    openssl
    grafana-loki
    makemkv
    handbrake
    smartmontools
  ];

  users.users.jellyfin = {
    isSystemUser = true;
    uid = 996;
    group = "jellyfin";
  };
  users.groups.jellyfin.gid = 996;

  users.users.paperless = {
    isSystemUser = true;
    uid = 315;
    group = "paperless";
  };
  users.groups.paperless.gid = 315;

  users.users.vaultwarden = {
    isSystemUser = true;
    uid = 988;
    group = "vaultwarden";
  };
  users.groups.vaultwarden.gid = 986;

  users.users.grafana = {
    isSystemUser = true;
    uid = 196;
    group = "grafana";
  };
  users.groups.grafana.gid = 985;

  users.users.nextcloud = {
    isSystemUser = true;
    uid = 995;
    group = "nextcloud";
  };
  users.groups.nextcloud.gid = 995;

  users.users.mosquitto = {
    isSystemUser = true;
    uid = 246;
    group = "mosquitto";
  };
  users.groups.mosquitto.gid = 246;

  users.users.dnsmasq = {
    isSystemUser = true;
    uid = 997;
    group = "dnsmasq";
  };
  users.groups.dnsmasq.gid = 997;

  users.users.loki = {
    isSystemUser = true;
    uid = 987;
    group = "loki";
  };
  users.groups.loki.gid = 984;

  users.users.prometheus = {
    isSystemUser = true;
    uid = 255;
    group = "prometheus";
  };
  users.groups.prometheus.gid = 255;

  services = {
    # ddclient = {
    #   enable = true;
    #   use = "web, web=https://cloudflare.com/cdn-cgi/trace";
    #   protocol = "cloudflare";
    #   ipv6 = false;
    #   passwordFile = "/persist/secrets/ddclient";
    #   domains = [
    #     "vpn.rickhenry.xyz"
    #   ];
    #   extraConfig = ''
    #     login=rickhenry@rickhenry.dev
    #   '';
    # };
    cloudflare-dyndns = {
      enable = true;
      apiTokenFile = "/persist/secrets/cloudflare-dyndns";
      domains = [ "vpn.rickhenry.xyz" ];
      ipv4 = true;
      ipv6 = true;
    };

    # home-assistant = {
    #   enable = true;
    #   config = {
    #     default_config = { };
    #     http = {
    #       base_url = "https://home.rickhenry.house";
    #       use_x_forwarded_for = true;
    #       trusted_proxies = "127.0.0.1";
    #     };
    #   };
    # };
    #
    # mosquitto = {
    #   enable = true;
    #   persistence = true;
    #   listeners = [
    #     {
    #       port = 1883;
    #       users = {
    #         blacklamp.hashedPasswordFile = "/persist/passwd/mosquitto/blacklamp";
    #         silverlamp.hashedPasswordFile = "/persist/passwd/mosquitto/silverlamp";
    #         desklight.hashedPasswordFile = "/persist/passwd/mosquitto/desklight";
    #       };
    #     }
    #   ];
    # };

    jellyfin.enable = true;
    # jellyseerr.enable = true;
    # sonarr.enable = true;

    nextcloud = {
      enable = true;
      package = pkgs.nextcloud27;
      hostName = "localhost";
      https = true;
      config = {
        adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
        extraTrustedDomains = [
          "next.rickhenry.xyz"
          "next.rickhenry.house"
          "10.7.0.100"
        ];
      };
      # extraApps = with config.services.nextcloud.package.packages.apps; {
      #   inherit contacts calendar tasks;
      # };
      appstoreEnable = true;
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

    nginx.virtualHosts."localhost".listen = [
      {
        addr = "127.0.0.1";
        port = 8080;
      }
    ];

    sanoid = {
      enable = true;
      datasets = {
        "rpool/safe" = {
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "vroom/impermanence" = {
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "vroom/vaultwarden" = {
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "vroom/paperless" = {
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "vroom/media" = {
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        # not backuptank
        # some of vroom
      };
    };

    syncoid = {
      enable = true;
      interval = "hourly";
      commonArgs = [
        "--compress=zstd-slow"
        "--recursive"
      ];
      commands = {
        "rpool/safe" = {
          target = "backuptank/host/rpool/safe";
        };
        "vroom" = {
          target = "backuptank/host/vroom";
          recursive = true;
          extraArgs = [
            "--exclude='.*vroom.rips.*'"
            "--exclude='.*vroom.downloads.*'"
            "--exclude='.*vroom.*blackhole.*'"
          ];
        };
      };
    };

    restic.backups.myaccount = {
      environmentFile = "/persist/secrets/restic/env";
      initialize = true;
      passwordFile = "/persist/secrets/restic/password";
      paths = [
        "/home/rick"
        "/persist"
        "/vroom-impermanence"
        "/vroom/paperless"
        "/vroom/media/music"
        "/backuptank/vw-backups"
        "/srv/git"
      ];
      exclude = [
        ".zfs"
        "/srv/restic"
        "/srv/arqbackup"
      ];
      extraBackupArgs = [
        "--exclude-if-present .NOBACKUP"
      ];

      repository = "b2:chopin-backup";
      timerConfig = {
        OnUnitActiveSec = "1d";
      };

      pruneOpts = [
        "--keep-daily=7"
        "--keep-weekly=2"
        "--keep-monthly=1"
        "--keep-yearly=0"
      ];
    };

    restic.backups.e2 = {
      environmentFile = "/persist/secrets/restic/e2-env";
      initialize = true;
      passwordFile = "/persist/secrets/restic/password";
      paths = [
        "/home/rick"
        "/persist"
        "/vroom-impermanence"
        "/vroom/paperless"
        "/vroom/media/music"
        "/backuptank/vw-backups"
        "/srv/git"
      ];
      exclude = [
        ".zfs"
        "/srv/restic"
        "/srv/arqbackup"
      ];
      extraBackupArgs = [
        "--exclude-if-present .NOBACKUP"
      ];

      repository = "s3:p4e4.va.idrivee2-58.com/berg-restic/berg";
      timerConfig = {
        OnUnitActiveSec = "1d";
      };

      pruneOpts = [
        "--keep-daily=7"
        "--keep-weekly=2"
        "--keep-monthly=1"
        "--keep-yearly=0"
      ];
    };

    samba = {
      openFirewall = true;
      enable = true;
      securityType = "user";
      extraConfig = ''
        workgroup = WORKGROUP
        server string = albanberg
        netbios name = albanberg
        security = user
        #use sendfile = yes
        #max protocol = smb2
        # note: localhost is the ipv6 localhost ::1
        hosts allow = 10.0.1. 10.7.0. 127.0.0.1 localhost
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
        "stravinsky-backup" = {
          path = "/srv/arqbackup/stravinsky-mac";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "rick";
          "force group" = "users";
          "valid users" = "rick";
        };
        "wright-backup" = {
          path = "/srv/arqbackup/wright";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "rick";
          "force group" = "users";
          "valid users" = "rick";
        };
        "other-backups" = {
          path = "/srv/otherbackups";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "rick";
          "force group" = "users";
          "valid users" = "rick";
        };
        "rips" = {
          path = "/vroom/rips";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "rick";
          "force group" = "users";
          "valid users" = "rick";
        };
        "media" = {
          path = "/vroom/media";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "jellyfin";
          "force group" = "jellyfin";
          "valid users" = "rick";
        };
      };
    };


    vaultwarden = {
      enable = true;
      backupDir = "/backuptank/vw-backups";
      config = {
        DOMAIN = "https://vault.rickhenry.xyz";
        SIGNUPS_ALLOWED = false;
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";
        # USE_SENDMAIL = true;
        # TODO: smtp config
      };
      environmentFile = "/persist/secrets/vaultwarden.env";
    };

    smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        mail = {
          enable = true;
          recipient = "rickhenry@rickhenry.dev";
        };
      };
    };

    paperless = {
      enable = true;
      dataDir = "/vroom/paperless";
      mediaDir = "/vroom/paperless/media";
      consumptionDir = "/vroom/paperless/consume";
      port = 28981;
      address = "localhost";
    };

    caddy = {
      enable = true;
      virtualHosts = {
        "jelly.rickhenry.xyz".extraConfig = ''
          reverse_proxy :8096
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "seerr.rickhenry.xyz".extraConfig = ''
          reverse_proxy 10.0.0.178:5055
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "sonarr.rickhenry.xyz".extraConfig = ''
          reverse_proxy 10.0.0.178:8989
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "radarr.rickhenry.xyz".extraConfig = ''
          reverse_proxy 10.0.0.178:7878
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "home.rickhenry.xyz".extraConfig = ''
          reverse_proxy {
            to :8123
            header_up Host {host}
            header_up X-Real-IP {remote_host}
          }
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "next.rickhenry.xyz".extraConfig = ''
          reverse_proxy :8080
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "vault.rickhenry.xyz".extraConfig = ''
          reverse_proxy :8222
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "audio.rickhenry.xyz".extraConfig = ''
          reverse_proxy localhost:13378
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "prox.rickhenry.xyz".extraConfig = ''
          reverse_proxy {
            to https://10.0.1.176:8006
            transport http {
              tls
              tls_insecure_skip_verify
              read_buffer 8192
            }
          }
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "gitlab.rickhenry.xyz".extraConfig = ''
          reverse_proxy http://10.0.1.171:80
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "gitea.rickhenry.xyz".extraConfig = ''
          reverse_proxy http://10.0.1.240:3000
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "paper.rickhenry.xyz".extraConfig = ''
          reverse_proxy http://localhost:28981
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
      };
    };

    dnsmasq = {
      enable = true;
      settings = {
        interface = "wg0";
        address = [
          "/next.rickhenry.xyz/10.7.0.100"
          "/home.rickhenry.xyz/10.7.0.100"
          "/jelly.rickhenry.xyz/10.7.0.100"
          "/seerr.rickhenry.xyz/10.7.0.100"
          "/sonarr.rickhenry.xyz/10.7.0.100"
          "/radarr.rickhenry.xyz/10.7.0.100"
          "/vault.rickhenry.xyz/10.7.0.100"
          "/prox.rickhenry.xyz/10.7.0.100"
          "/audio.rickhenry.xyz/10.7.0.100"
          "/paper.rickhenry.xyz/10.7.0.100"
        ];
      };
    };

    zfs = {
      autoSnapshot.enable = false;
      trim = {
        enable = true;
        interval = "weekly";
      };
      zed.settings = {
        ZED_DEBUG_LOG = "/tmp/zed.debug.log";

        ZED_EMAIL_ADDR = [ "rickhenry@rickhenry.dev" ];
        ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/sendmail";
        ZED_EMAIL_OPTS = "@ADDRESS@";

        ZED_NOTIFY_INTERVAL_SECS = 3600;
        ZED_NOTIFY_VERBOSE = true;

        ZED_USE_ENCLOSURE_LEDS = true;
        ZED_SCRUB_AFTER_RESILVER = true;
      };
      autoScrub = {
        enable = true;
        pools = [
          "rpool"
          "backuptank"
          "vroom"
        ];
      };
    };

    nfs.server = {
      enable = true;
      lockdPort = 4001;
      mountdPort = 4002;
      statdPort = 4000;
      exports = ''
        /backuptank/proxmox 10.0.1.0/16(rw,sync,crossmnt,no_subtree_check,all_squash)
        /vroom/media 10.0.0.0/16(rw,sync,crossmnt,no_subtree_check,no_root_squash)
        /vroom/downloads 10.20.0.0/16(rw,sync,crossmnt,no_subtree_check,all_squash,anonuid=996,anongid=996)
        /vroom/blackhole 10.20.0.0/16(rw,sync,crossmnt,no_subtree_check,all_squash,anonuid=996,anongid=996)
        /vroom/downloads 10.0.0.0/16(rw,sync,crossmnt,no_subtree_check,all_squash,anonuid=996,anongid=996)
        /vroom/blackhole 10.0.0.0/16(rw,sync,crossmnt,no_subtree_check,all_squash,anonuid=996,anongid=996)
      '';
    };

  };

  # systemd.services.promtail = {
  #   description = "Promtail service for loki";
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     ExecStart = ''
  #       ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtail.yaml}
  #     '';
  #   };
  # };

  security.acme = {
    acceptTerms = true;
    defaults.email = "rickhenry@rickhenry.dev";
    certs."rickhenry.xyz" = {
      domain = "*.rickhenry.xyz";
      dnsProvider = "cloudflare";
      credentialsFile = "/persist/secrets/acme/cloudflare";
      group = config.services.caddy.group;
    };
  };

  programs.msmtp = {
    enable = true;
    accounts.default = {
      auth = true;
      tls = true;
      from = "berg@mg.rickhenry.xyz";
      user = "berg@mg.rickhenry.xyz";
      passwordeval = "cat /persist/secrets/msmtp";
      host = "smtp.mailgun.org";
    };
  };

  virtualisation.podman.enable = true;

  virtualisation.oci-containers.containers."audiobookshelf" = {
    autoStart = true;
    image = "ghcr.io/advplyr/audiobookshelf:latest";
    environment = {
      AUDIOBOOKSHELF_UID = "99";
      AUDIOBOOKSHELF_GID = "100";
    };
    ports = [ "13378:80" ];
    volumes = [
      "/vroom/audio/Audiobooks:/audiobooks"
      "/vroom/audio/Podcasts:/podcasts"
      "/vroom/audio/Containers/Audiobookshelf/config:/config"
      "/vroom/audio/Containers/Audiobookshelf/audiobooks:/metadata"
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
      mtu = 1410;
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
        {
          # iphone
          publicKey = "upN/jrQg85q9T8nU5OGPy3rgdSw3IpstRpkXn8Nbizk=";
          allowedIPs = [ "10.7.0.40/32" ];
          presharedKeyFile = "/persist/secrets/wireguard/iphone-psk";
          persistentKeepalive = 25;
        }
        {
          # wright
          publicKey = "9/MFu6dR2rUD1r09xXff+coVh6khUVY/5pOFU/gOTTU=";
          allowedIPs = [ "10.7.0.50/32" ];
          presharedKeyFile = "/persist/secrets/wireguard/wright-psk";
          persistentKeepalive = 25;
        }
      ];
    };
    wg1 = {
      address = [ "10.20.0.100/24" ];
      mtu = 1410;
      privateKeyFile = "/persist/secrets/wireguard/privkey2";
      peers = [
        {
            # seedbox
            publicKey = "UFvFwch3p44/FTPynAOBIhYpQLV66jh+quw0QprFXx0=";
            allowedIPs = [ "10.20.0.20/32" ];
            presharedKeyFile = "/persist/secrets/wireguard/seed-psk";
            endpoint = "165.22.203.219:51821";
            persistentKeepalive = 25;
        }
        {
            # flyingdutchman
            publicKey = "+z2Yc31fNyxCm2oYjYzLvcIBGbivFr7uudvp5hCnswk=";
            allowedIPs = [ "10.20.0.10/32" ];
            presharedKeyFile = "/persist/secrets/wireguard/dutchman-psk";
            persistentKeepalive = 25;
        }
      ];
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 53 8123 8096 8222 5357 80 443 111 2049 4000 4001 4002 20048 ];
    allowedUDPPorts = [ 53 5353 51820 5357 111 2049 4000 4001 4002 20048 ];
    extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
    allowPing = true;
  };

  boot.zfs.extraPools = [
    "backuptank"
    "vroom"
  ];

  # WIPE ROOT CONFIGURATION
  environment.persistence."/persist/impermanence" = {
    directories = [
      "/etc/nixos"
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

  environment.persistence."/vroom-impermanence" = {
    hideMounts = true;
    directories = [
      "/var"
    ];
  };

  boot.initrd.postDeviceCommands =
    lib.mkAfter
      ''
        zfs rollback -r rpool/local/root@blank
      '';

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/vroom-impermanence".neededForBoot = true;

  # TODO: additional samba shares

  nix.settings.sandbox = false;

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startxfce4";
  services.xrdp.openFirewall = true;
}
