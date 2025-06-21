{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-id";
  boot.tmp.tmpfsSize = "8G";
  boot.kernelParams = [ "nohibernate" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
