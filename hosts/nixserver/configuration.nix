{ config
, pkgs
, lib
, unstablePkgs
, ...
}:
let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
  secrets = import ./secrets.nix { };
in
{
  imports = [
    ../_common/linux/configuration/boot.nix
    ../_common/linux/configuration/basic.nix
    ../_common/linux/configuration/virt.nix
    ../_common/linux/configuration/users-rick.nix
    ../_common/rick-passwordless-sudo.nix
    ../_common/linux/configuration/xconfig-noi3.nix
    ./hardware-configuration.nix
    "${impermanence}/nixos.nix"
  ];

  users.users.rick.shell = pkgs.zsh;
  programs.zsh.enable = true;

  networking.hostName = "albanberg";
  networking.hostId = "d4e76b17";
  networking.nat.internalInterfaces = [ "wg0" ];

  environment.systemPackages = [
    # essentials
    pkgs.firefox
    pkgs.neovim
    pkgs.git

    pkgs.alacritty
    pkgs.xorg.xinit
    pkgs.killall
    pkgs.xdotool
    pkgs.xorg.xwininfo

    pkgs.home-manager

    pkgs.fish
    pkgs.wireguard-tools
    pkgs.tree
    pkgs.curl

    pkgs.virt-manager
    pkgs.virt-viewer

    pkgs.unzip
    pkgs.zip
    pkgs.restic

    pkgs.openssl
    pkgs.makemkv
    pkgs.handbrake
    pkgs.smartmontools
    unstablePkgs.jellyfin-ffmpeg
    pkgs.intel-media-driver
    pkgs.intel-gpu-tools
    pkgs.vaapiIntel
    pkgs.vaapiVdpau
    pkgs.libvdpau-va-gl
    pkgs.intel-compute-runtime
    pkgs.iperf
    pkgs.vlc
    pkgs.xfce.xfce4-whiskermenu-plugin
    pkgs.btrfs-progs
    pkgs.lame
    pkgs.flac
    pkgs.id3v2
    pkgs.fd
    pkgs.calibre
    pkgs.cuetools
    pkgs.shntool
    pkgs.wineWowPackages.stable
    pkgs.vivaldi
    pkgs.viu
    pkgs.mediainfo
    pkgs.sox
    pkgs.gptfdisk
    pkgs.mktorrent
    pkgs.rdfind
    pkgs.puddletag
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
    atuin = {
      enable = true;
      database.createLocally = true;
      openRegistration = false;
    };
    cloudflare-dyndns = {
      enable = true;
      apiTokenFile = "/persist/secrets/cloudflare-dyndns";
      domains = [ "vpn.rickhenry.xyz" ];
      ipv4 = true;
      ipv6 = true;
    };

    jellyfin.enable = true;
    jellyfin.package = unstablePkgs.jellyfin;
    # kavita = {
    #   enable = true;
    #   tokenKeyFile = "/persist/secrets/kavita-token";
    #   user = "jellyfin";
    # };

    calibre-web = {
      enable = true;
      user = "jellyfin";
      group = "users";
      options.calibreLibrary = "/vroom/media/calibre/";
      # options.calibreLibrary = "/var/lib/calibre-web";
      options.enableBookUploading = true;
      options.enableBookConversion = true;
      listen.port = 8083;
      listen.ip = "0.0.0.0";
    };

    navidrome = {
      enable = true;
      user = "jellyfin";
      group = "users";
      settings = {
        MusicFolder = "/vroom/media/music";
        Port = 4533;
        Address = "0.0.0.0";
        AutoImportPlaylists = false;
        EnableTranscodingConfig = true;
        "LastFM.Enabled" = true;
        "LastFM.ApiKey" = secrets.navidrome.lastfm.apikey;
        "LastFM.Secret" = secrets.navidrome.lastfm.secret;
        "Spotify.ID" = secrets.navidrome.spotify.clientid;
        "Spotify.Secret" = secrets.navidrome.spotify.clientsecret;
      };
    };

    nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = "localhost";
      https = true;
      settings = {
        trusted_domains = [
          "next.rickhenry.xyz"
          "next.rickhenry.house"
          "10.7.0.100"
        ];

        mail_smtpmode = "sendmail";
        mail_sendmailmode = "pipe";
      };
      config = {
        adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
        dbtype = "sqlite";
      };
      appstoreEnable = true;
      extraAppsEnable = true;
      configureRedis = true;
      secretFile = "/etc/nextcloud-secrets.json";
      phpOptions = {
        upload_max_filesize = lib.mkForce "16G";
        post_max_size = lib.mkForce "16G";
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
          yearly = 0;
          hourly = 12;
          daily = 7;
          weekly = 4;
          monthly = 6;
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "vroom/impermanence" = {
          yearly = 1;
          hourly = 12;
          daily = 7;
          weekly = 2;
          monthly = 12;
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "vroom/vaultwarden" = {
          yearly = 0;
          hourly = 12;
          daily = 7;
          weekly = 2;
          monthly = 3;
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "vroom/paperless" = {
          yearly = 0;
          hourly = 12;
          daily = 7;
          weekly = 2;
          monthly = 3;
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "vroom/media" = {
          yearly = 0;
          daily = 7;
          weekly = 2;
          monthly = 3;
          hourly = 24;
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "spinny/media" = {
          yearly = 0;
          hourly = 12;
          daily = 7;
          weekly = 2;
          monthly = 3;
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "spinny/stash2" = {
          yearly = 0;
          monthly = 1;
          daily = 1;
          weekly = 4;
          hourly = 12;
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "vroom/nextcloud" = {
          yearly = 0;
          hourly = 12;
          daily = 7;
          weekly = 2;
          monthly = 3;
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "vroom/rick" = {
          yearly = 0;
          hourly = 12;
          daily = 7;
          weekly = 2;
          monthly = 6;
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "spinny/rick" = {
          yearly = 0;
          hourly = 12;
          daily = 7;
          weekly = 2;
          monthly = 6;
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "backuptank/vw-backups" = {
          yearly = 0;
          hourly = 12;
          daily = 7;
          weekly = 2;
          monthly = 1;
          recursive = true;
          autosnap = true;
          autoprune = true;
        };
        "backuptank" = {
          yearly = 0;
          monthly = 1;
          weekly = 1;
          daily = 1;
          hourly = 1;
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
        "--no-sync-snap"
      ];
      commands = {
        "rpool/safe" = {
          target = "backuptank/host/rpool/safe";
          recursive = true;
        };
        "vroom/media" = {
          target = "backuptank/host/vroom/media";
          recursive = true;
        };
        # "spinny/media" = {
        #   target = "backuptank/host/spinny/media";
        #   recursive = true;
        # };
        # "spinny/stash2" = {
        #   target = "backuptank/host/spinny/stash2";
        #   recursive = true;
        # };
        "vroom/nextcloud" = {
          target = "backuptank/host/vroom/nextcloud";
          recursive = true;
        };
        "vroom/rick" = {
          target = "backuptank/host/vroom/rick";
          recursive = true;
        };
        "spinny/rick" = {
          target = "backuptank/host/spinny/rick";
          recursive = true;
        };
        "vroom/vaultwarden" = {
          target = "backuptank/host/vroom/vaultwarden";
          recursive = true;
        };
        "vroom/impermanence" = {
          target = "backuptank/host/vroom/impermanence";
          recursive = true;
        };
        "vroom/paperless" = {
          target = "backuptank/host/vroom/paperless";
          recursive = true;
        };
        # "backuptank" = {
        #   target = "external/backuptank";
        #   recursive = true;
        #   extraArgs = [
        #     "--delete-target-snapshots"
        #   ];
        # };
      };
    };

    cron = {
      enable = true;
      systemCronJobs = [
        "0 4 * * * root sh -c 'zpool trim vroom'"
        "0 5 * * * root sh -c 'rsync -aAX /mnt/linuxisos/seeds/upload /backuptank/host/linuxisos/upload"
      ];
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
        "/mnt/linuxisos/seeds/upload"
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
        "/mnt/linuxisos/seeds/upload"
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
      settings = {
        global = {
          security = "user";
          workgroup = "WORKGROUP";
          "server string" = "albanberg";
          "hosts allow" = "10.0.1. 10.7.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
          "mangled names" = "no";
          "dos charset" = "UTF-8";
          "unix charset" = "UTF-8";
          "display charset" = "UTF-8";
          "veto files" = "/._*/.DS_Store/";
        };
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
        "spinny-media" = {
          path = "/spinny/media";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "jellyfin";
          "force group" = "jellyfin";
          "valid users" = "rick";
        };
        "linuxisos" = {
          path = "/mnt/linuxisos";
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

    # paperless = {
    #   enable = true;
    #   dataDir = "/vroom/paperless";
    #   mediaDir = "/vroom/paperless/media";
    #   consumptionDir = "/vroom/paperless/consume";
    #   port = 28981;
    #   address = "localhost";
    # };

    caddy = {
      enable = true;
      virtualHosts = {
        "jelly.rickhenry.xyz".extraConfig = ''
          reverse_proxy :8096
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "navidrome.rickhenry.xyz".extraConfig = ''
          reverse_proxy :4533
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "cb.rickhenry.xyz".extraConfig = ''
          reverse_proxy :8001
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "calibre.rickhenry.xyz".extraConfig = ''
          reverse_proxy localhost:8083
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "stash.rickhenry.xyz".extraConfig = ''
          reverse_proxy :9999
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
        "readarr.rickhenry.xyz".extraConfig = ''
          reverse_proxy 10.0.0.178:8787
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "lidarr.rickhenry.xyz".extraConfig = ''
          reverse_proxy 10.0.0.178:8686
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "jackett.rickhenry.xyz".extraConfig = ''
          reverse_proxy 10.0.0.178:9117
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "qb.rickhenry.xyz".extraConfig = ''
          reverse_proxy 10.0.0.178:8080
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "kavita.rickhenry.xyz".extraConfig = ''
          reverse_proxy :5000
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
        "prox.rickhenry.xyz".extraConfig = ''
          reverse_proxy {
            to https://10.0.0.112:8006
            transport http {
              tls
              tls_insecure_skip_verify
              read_buffer 8192
            }
          }
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "paper.rickhenry.xyz".extraConfig = ''
          reverse_proxy http://localhost:28981
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "audio.rickhenry.xyz".extraConfig = ''
          reverse_proxy http://localhost:13378
          tls /var/lib/acme/rickhenry.xyz/cert.pem /var/lib/acme/rickhenry.xyz/key.pem
        '';
        "atuin.rickhenry.xyz".extraConfig = ''
          reverse_proxy http://localhost:8888
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
          "/navidrome.rickhenry.xyz/10.7.0.100"
          "/calibre.rickhenry.xyz/10.7.0.100"
          "/cb.rickhenry.xyz/10.7.0.100"
          "/seerr.rickhenry.xyz/10.7.0.100"
          "/sonarr.rickhenry.xyz/10.7.0.100"
          "/radarr.rickhenry.xyz/10.7.0.100"
          "/jackett.rickhenry.xyz/10.7.0.100"
          "/qb.rickhenry.xyz/10.7.0.100"
          "/vault.rickhenry.xyz/10.7.0.100"
          "/prox.rickhenry.xyz/10.7.0.100"
          "/paper.rickhenry.xyz/10.7.0.100"
          "/stash.rickhenry.xyz/10.7.0.100"
          "/whisparr.rickhenry.xyz/10.7.0.100"
          "/readarr.rickhenry.xyz/10.7.0.100"
          "/kavita.rickhenry.xyz/10.7.0.100"
          "/lidarr.rickhenry.xyz/10.7.0.100"
          "/audio.rickhenry.xyz/10.7.0.100"
          "/atuin.rickhenry.xyz/10.7.0.100"
          "/printer.rickhenry.xyz/10.7.0.100"
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
          "spinny"
        ];
      };
    };
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [ "/mnt/linuxisos" ];
    };

    nfs.server = {
      enable = true;
      lockdPort = 4001;
      mountdPort = 4002;
      statdPort = 4000;
      exports = ''
          /backuptank/proxmox 10.0.1.0/16(rw,sync,crossmnt,no_subtree_check,all_squash)
          /vroom/media 10.0.0.0/16(rw,sync,crossmnt,no_subtree_check,all_squash,anonuid = 996,anongid=996)
        /spinny/media 10.0.0.0/16(rw,sync,crossmnt,no_subtree_check,all_squash,anonuid=996,anongid=996)
        /backuptank/downloads 10.0.0.0/16(rw,sync,crossmnt,no_subtree_check,all_squash,anonuid=996,anongid=996)
        /vroom/blackhole 10.0.0.0/16(rw,sync,crossmnt,no_subtree_check,all_squash,anonuid=996,anongid=996)
        /vroom/books 10.0.0.0/16(rw,sync,crossmnt,no_subtree_check,all_squash,anonuid=996,anongid=996)
        /opt/stash 10.0.0.0/16(rw,sync,crossmnt,no_subtree_check,all_squash,anonuid=996,anongid=100)
        /mnt/linuxisos/seeds 10.0.0.0/16(rw,sync,crossmnt,no_subtree_check,all_squash,anonuid=1000,anongid=100)
        /mnt/linuxisos/extracted 10.0.0.0/16(rw,sync,crossmnt,no_subtree_check,all_squash,anonuid=996,anongid=100)
        /srv/rick 10.0.0.0/16(rw,sync,crossmnt,no_subtree_check,all_squash,anonuid=1000,anongid=100)
      '';
    };

    snapper = {
      snapshotInterval = "hourly";
      cleanupInterval = "1d";
      configs = {
        # uploads = {
        #   SUBVOLUME = "/mnt/linuxisos/seeds/upload";
        #   TIMELINE_CREATE = true;
        #   TIMELINE_CLEANUP = true;
        #   TIMELINE_LIMIT_HOURLY = "10";
        #   TIMELINE_LIMIT_DAILY = "7";
        #   TIMELINE_LIMIT_WEEKLY = "2";
        #   TIMELINE_LIMIT_MONTHLY = "0";
        #   TIMELINE_LIMIT_YEARLY = "0";
        #   BACKGROUND_COMPARISON = "yes";
        #   NUMBER_CLEANUP = "no";
        #   NUMBER_MIN_AGE = "1800";
        #   NUMBER_LIMIT = "50";
        #   NUMBER_LIMIT_IMPORTANT = "10";
        #   EMPTY_PRE_POST_CLEANUP = "yes";
        #   EMPTY_PRE_POST_MIN_AGE = "1800";
        # };
        seeds = {
          SUBVOLUME = "/mnt/linuxisos/seeds";
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
          TIMELINE_LIMIT_HOURLY = "24";
          TIMELINE_LIMIT_DAILY = "1";
          TIMELINE_LIMIT_WEEKLY = "1";
          TIMELINE_LIMIT_MONTHLY = "0";
          TIMELINE_LIMIT_YEARLY = "0";
          BACKGROUND_COMPARISON = "yes";
          NUMBER_CLEANUP = "no";
          NUMBER_MIN_AGE = "1800";
          NUMBER_LIMIT = "50";
          NUMBER_LIMIT_IMPORTANT = "10";
          EMPTY_PRE_POST_CLEANUP = "yes";
          EMPTY_PRE_POST_MIN_AGE = "1800";
        };
      };
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

  virtualisation.oci-containers.containers."stash" = {
    autoStart = true;
    image = "stashapp/stash:latest";
    ports = [ "9999:9999" ];
    environment = {
      STASH_STASH = "/data/";
      STASH_GENERATED = "/generated/";
      STASH_METADATA = "/metadata/";
      STASH_CACHE = "/cache/";
      STASH_PORT = "9999";
    };
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/opt/stash/config:/root/.stash"
      "/opt/stash/data:/data"
      "/opt/stash/data2:/data2"
      "/opt/stash/metadata:/metadata"
      "/opt/stash/cache:/cache"
      "/opt/stash/blobs:/blobs"
      "/opt/stash/generated:/generated"
    ];
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
      "/spinny/media/audiobooks:/audiobooks"
      "/vroom/configs/audiobookshelf/config:/config"
      "/vroom/configs/audiobookshelf/metadata:/metadata"
    ];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
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
    # wg1 = {
    #   address = [ "10.20.0.100/24" ];
    #   mtu = 1410;
    #   privateKeyFile = "/persist/secrets/wireguard/privkey2";
    #   peers = [
    #     {
    #         # seedbox
    #         publicKey = "UFvFwch3p44/FTPynAOBIhYpQLV66jh+quw0QprFXx0=";
    #         allowedIPs = [ "10.20.0.20/32" ];
    #         presharedKeyFile = "/persist/secrets/wireguard/seed-psk";
    #         endpoint = "165.22.203.219:51821";
    #         persistentKeepalive = 25;
    #     }
    #     {
    #         # flyingdutchman
    #         publicKey = "+z2Yc31fNyxCm2oYjYzLvcIBGbivFr7uudvp5hCnswk=";
    #         allowedIPs = [ "10.20.0.10/32" ];
    #         presharedKeyFile = "/persist/secrets/wireguard/dutchman-psk";
    #         persistentKeepalive = 25;
    #     }
    #   ];
    # };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 53 8123 8096 8222 5357 80 443 111 2049 4000 4001 4002 5201 20048 8083 8001 55110 5000 ];
    allowedUDPPorts = [ 53 5353 51820 5357 111 2049 4000 4001 4002 20048 ];
    extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
    allowPing = true;
  };

  boot.zfs.extraPools = [
    "backuptank"
    "vroom"
    # "external"
    "spinny"
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

  nix.optimise.automatic = true;
}
