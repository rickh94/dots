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
}
