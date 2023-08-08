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
      ../_common/rick-passwordless-sudo.nix
      ./hardware-configuration.nix
      "${impermanence}/nixos.nix"
    ];


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
        http = {
          base_url = "https://home.rickhenry.house";
          use_x_forwarded_for = true;
          trusted_proxies = "127.0.0.1";
        };
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
      https = true;
      config = {
        adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
        extraTrustedDomains = [
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
        "vroom/impermanence" = {
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "tank/srv/rick" = {
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
        "tank/media" = {
          target = "backuptank/host/tank/media";
          useCommonArgs = false;
          extraArgs = [
            "--compress=none"
            "--recursive"
          ];
        };
        "tank/srv/rick" = {
          target = "backuptank/host/tank/srv-rick";
        };
        "tank/vw-backups" = {
          target = "backuptank/host/tank/vw-backups";
        };
        "vroom/impermanence" = {
          target = "backuptank/host/vroom/impermanence";
        };
        "vroom/vaultwarden" = {
          target = "backuptank/host/vroom/vaultwarden";
        };
        "vroom/paperless" = {
          target = "backuptank/host/vroom/paperless";
        };
      };
    };

    restic.backups.myaccount = {
      environmentFile = "/persist/secrets/restic/env";
      initialize = true;
      passwordFile = "/persist/secrets/restic/password";
      paths = [
        "/home/rick"
        "/tank/media/music"
        "/tank/nextcloud"
        "/tank/vw-backups"
        "/persist"
        "/vroom-impermanence"
        "/vroom/paperless"
        "/srv/rick"
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
      };

    };

    grafana = {
      enable = true;
      settings = {
        security = {
          secret_key = "$__file{/persist/secrets/grafana/secret_key}";
        };
      };
    };

    prometheus = {
      enable = true;
      port = 9001;
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = 9002;
        };
        zfs = {
          enable = true;
          port = 9003;
        };
        wireguard = {
          enable = true;
          port = 9005;
        };
        smartctl = {
          enable = true;
          port = 9006;
        };
        dnsmasq = {
          enable = true;
          port = 9008;
        };
      };
      scrapeConfigs = [
        {
          job_name = "albanberg";
          static_configs = [{
            targets = [
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
              "127.0.0.1:${toString config.services.prometheus.exporters.zfs.port}"
              "127.0.0.1:${toString config.services.prometheus.exporters.wireguard.port}"
              "127.0.0.1:${toString config.services.prometheus.exporters.smartctl.port}"
              "127.0.0.1:${toString config.services.prometheus.exporters.dnsmasq.port}"
            ];
          }];
        }
      ];
    };

    loki = {
      enable = true;
      configFile = ./loki-local-config.yaml;
    };

    vaultwarden = {
      enable = true;
      backupDir = "/backuptank/vw-backups";
      config = {
        DOMAIN = "https://vault.rickhenry.house";
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
        "jelly.rickhenry.house".extraConfig = ''
          reverse_proxy :8096
          tls /var/lib/acme/rickhenry.house/cert.pem /var/lib/acme/rickhenry.house/key.pem
        '';
        "home.rickhenry.house".extraConfig = ''
          reverse_proxy {
            to :8123
            header_up Host {host}
            header_up X-Real-IP {remote_host}
            header_up x-forwarded-for {remote_host}
            header_up X-Forwarded-Proto {scheme}
          }
          tls /var/lib/acme/rickhenry.house/cert.pem /var/lib/acme/rickhenry.house/key.pem
        '';
        "next.rickhenry.house".extraConfig = ''
          reverse_proxy :8080
          tls /var/lib/acme/rickhenry.house/cert.pem /var/lib/acme/rickhenry.house/key.pem
        '';
        "vault.rickhenry.house".extraConfig = ''
          reverse_proxy :8222
          tls /var/lib/acme/rickhenry.house/cert.pem /var/lib/acme/rickhenry.house/key.pem
        '';
        "audio.rickhenry.house".extraConfig = ''
          reverse_proxy localhost:13378
          tls /var/lib/acme/rickhenry.house/cert.pem /var/lib/acme/rickhenry.house/key.pem
        '';
        "prox.rickhenry.house".extraConfig = ''
          reverse_proxy {
            to https://10.0.1.176:8006
            transport http {
              tls
              tls_insecure_skip_verify
              read_buffer 8192
            }
          }
          tls /var/lib/acme/rickhenry.house/cert.pem /var/lib/acme/rickhenry.house/key.pem
        '';
        "gitlab.rickhenry.house".extraConfig = ''
          reverse_proxy http://10.0.1.171:80
          tls /var/lib/acme/rickhenry.house/cert.pem /var/lib/acme/rickhenry.house/key.pem
        '';
        "gitea.rickhenry.house".extraConfig = ''
          reverse_proxy http://10.0.1.240:3000
          tls /var/lib/acme/rickhenry.house/cert.pem /var/lib/acme/rickhenry.house/key.pem
        '';
        "grafana.rickhenry.house".extraConfig = ''
          reverse_proxy http://localhost:3000
          tls /var/lib/acme/rickhenry.house/cert.pem /var/lib/acme/rickhenry.house/key.pem
        '';
        "paper.rickhenry.house".extraConfig = ''
          reverse_proxy http://localhost:28981
          tls /var/lib/acme/rickhenry.house/cert.pem /var/lib/acme/rickhenry.house/key.pem
        '';
        "ptero.rickhenry.house".extraConfig = ''
          reverse_proxy http://10.0.1.134:80
          tls /var/lib/acme/rickhenry.house/cert.pem /var/lib/acme/rickhenry.house/key.pem
        '';
      };
    };

    dnsmasq = {
      enable = true;
      settings = {
        interface = "wg0";
        address = [
          "/next.rickhenry.house/10.7.0.100"
          "/home.rickhenry.house/10.7.0.100"
          "/jelly.rickhenry.house/10.7.0.100"
          "/vault.rickhenry.house/10.7.0.100"
          "/prox.rickhenry.house/10.7.0.100"
          "/audio.rickhenry.house/10.7.0.100"
          "/gitlab.rickhenry.house/10.7.0.100"
          "/gitea.rickhenry.house/10.7.0.100"
          "/grafana.rickhenry.house/10.7.0.100"
          "/paper.rickhenry.house/10.7.0.100"
          "/ptero.rickhenry.house/10.7.0.100"
        ];
      };
    };

    zfs = {
      autoSnapshot.enable = false;
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
          "tank"
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
        /tank/proxmox 10.0.1.0/24(rw,sync,crossmnt,no_subtree_check,all_squash)
        /backuptank/proxmox 10.0.1.0/24(rw,sync,crossmnt,no_subtree_check,all_squash)
      '';
    };
  };

  systemd.services.promtail = {
    description = "Promtail service for loki";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtail.yaml}
      '';
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
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 53 8123 8096 8222 5357 80 443 111 2049 4000 4001 4002 20048 ];
    allowedUDPPorts = [ 53 5353 51820 5357 111 2049 4000 4001 4002 20048 ];
    extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
    allowPing = true;
  };

  boot.zfs.extraPools = [
    "tank"
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

  boot.initrd.postDeviceCommands = lib.mkAfter
    ''
      zfs rollback -r rpool/local/root@blank
    '';

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/vroom-impermanence".neededForBoot = true;

  # TODO: additional samba shares

  nix.settings.sandbox = false;
}

