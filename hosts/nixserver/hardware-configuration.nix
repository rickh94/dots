# THIS FILE NEEDS TO BE REPLACED
# this is generated with a vm. replace with the reeal beethoven generated config
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "nvme" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  ######## ZFS DATASET LAYOUT FOR ROOT DRIVE #######
  #  name          options          
  #  rpool         compression=on   mountpoint=none       
  #  rpool/local   compression=on   mountpoint=none     # no snapshots or backups
  #  rpool/local/root compression=on mountpoint=legacy acltype=posixacl xattr=sa # this one gets wiped every boot
  #  rpool/local/nix  compression=on mounpoint=legacy atime=off
  #  rpool/safe       compression=on  mounpoint=none    # snapshots/backups
  #  rpool/safe/persist compression=on mountpoint=legacy 
  #  rpool/safe/home    compression=on  mountpoint=legacy
  # DON'T FORGET TO SNAPSHOT

  fileSystems."/" =
    {
      device = "rpool/local/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    {
      device = "rpool/local/nix";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    {
      device = "rpool/safe/persist";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "rpool/safe/home";
      fsType = "zfs";
    };

  fileSystems."/vroom-impermanence" =
    {
      device = "vroom/impermanence";
      fsType = "zfs";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
