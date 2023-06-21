{ pkgs, ... }:
{

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
    sshKey = "/var/lib/syncoid/id_ed25519";
    interval = "daily";
    commands."chopin" = {
      source = "nvme/safe";
      target = "beethoven@chopin:backuptank/beethoven/nvme/safe";
      recursive = true;
      extraArgs = [ "--sshoption=StrictHostKeyChecking=off" ];
    };
  };

  security.sudo.extraRules = [
    { users = [ "syncoid" "sanoid" ]; commands = [{ command = "${pkgs.zfs}/bin/zfs"; options = [ "NOPASSWD" ]; }]; }
  ];
}
