{ lib, ... }:
{
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';

  # OPT-IN STATE
  environment.etc = {
    "nixos/configuration.nix" = {
      source = "/persist/etc/nixos/configuration.nix";
    };
    "nixos/hardware-configuration.nix" = {
      source = "/persist/etc/nixos/hardware-configuration.nix";
    };
    "nixos/wipe-root.nix" = {
      source = "/persist/etc/nixos/wipe-root.nix";
    };

    passwd = {
      source = "/persist/etc/passwd";
    };

    shadow = {
      source = "/persist/etc/shadow";
    };

    group = {
      source = "/persist/etc/group";
    };

    "machine-id" = {
      source = "/persist/etc/machine-id";
    };
  };

  services.openssh = {
    hostKeys = [
      {
        path = "/persist/ssh/ssh_host_ed25519_key";
	      type = "ed25519";
      }
      {
        path = "/persist/ssh/ssh_host_rsa_key";
	      type = "rsa";
	      bits = 4096;
      },
    ];
  };
}
