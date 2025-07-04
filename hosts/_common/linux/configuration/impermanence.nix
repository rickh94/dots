{ lib, ... }: {
  environment.persistence."/persist/impermanence" = {
    directories = [
      "/etc/nixos"
      "/var/lib/containers/storage"
      "/var/lib/nixos"
      "/var/lib/flatpak"
    ];
    files = [
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/machine-id"
    ];
  };

  boot.initrd.postResumeCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';

  fileSystems."/persist".neededForBoot = true;
}
