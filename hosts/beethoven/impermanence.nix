{ lib, ... }:
let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in
{
  imports = [
    "${impermanence}/nixos.nix"
  ];

  environment.persistence."/persist/impermanence" = {
    directories = [
      "/etc/nixos"
      "/var/lib/containers/storage"
    ];
    files = [
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/machine-id"
      "/var/lib/syncoid/id_ed25519"
      "/var/lib/syncoid/id_ed25519.pub"
    ];
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r nvme/local/root@blank
  '';

  fileSystems."/persist".neededForBoot = true;



}
