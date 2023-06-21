{ ... }:
{
  users.mutableUsers = false;
  users.users = {
    rick = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" ]; # Enable ‘sudo’ for the user.
      passwordFile = "/persist/passwd/rick";
      uid = 1000;
    };
  };
}
