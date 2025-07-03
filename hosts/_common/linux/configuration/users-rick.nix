{ ... }: {
  users.mutableUsers = false;
  users.users = {
    rick = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" "disk" "cdrom" "docker" ];
      hashedPasswordFile = "/persist/passwd/rick";
      uid = 1000;
    };
  };
}
