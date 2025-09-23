{ ... }: {
  
  users.users.copyparty = {
    isSystemUser = true;
    extraGroups = [
      "caddy"
      "jellyfin"
      "users"
    ];
  };

  services.copyparty = {
    enable = true;
    settings = {
      i = [
        "10.0.1.100"
        "unix:770:caddy:/dev/shm/party.sock"
      ];
      hist = "/var/lib/copyparty/hist";
    };

    accounts = {
      rick = {
        passwordFile = "/persist/secrets/copyparty/rick";
      };
      beethoven = {
        passwordFile = "/persist/secrets/copyparty/beethoven";
      };
      bach = {
        passwordFile = "/persist/secrets/copyparty/bach";
      };
      pds = {
        passwordFile = "/persist/secrets/copyparty/pds";
      };
    };


    volumes = {
      "/" = {
        path = "/srv/shr";
        flags = {
          daw = true;
          e2d = true;
        };
        access = {
          rwadmg = [ "rick"];
        };
      };
      "/rick" = {
        path = "/srv/rick";
        flags = {
          daw = true;
          e2d = true;
        };
        access = {
          "rwadmg." = [ "rick" ];
        };
      };

      "/music" = {
        path = "/vroom/media/music";
        access = {
          "rwadmg." = [ "rick" ];
        };
      };

      "/media" = {
        path = "/spinny/media";
        access = {
          "rwadmg." = [ "rick" ];
        };
      };

      "/backup" = {
        path = "/srv/backup";
        access = {
          "rwadmg." = [ "rick" ];
        };
      };

      "/backup/beethoven" = {
        path = "/srv/backup/beethoven";
        access = {
          "rwadmg." = [ "rick"  "beethoven" ];
        };
      };

      "/backup/bach" = {
        path = "/srv/backup/bach";
        access = {
          "rwadmg." = [ "rick"  "bach" ];
        };
      };

      "/backup/stravinsky" = {
        path = "/srv/backup/stravinsky";
        access = {
          "rwadmg." = [ "rick" ];
        };
      };

      "/backup/pds" = {
        path = "/srv/backup/pds";
        access = {
          "rwadmg." = [ "pds"  "rick"];
        };
      };

      "/shared" = {
        path = "/srv/shared";
        access = {
          "rwadmg." = [ "rick" ];
          rwg = "*";
        };
      };
    };
  };
}
