{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "xfce";
      lightdm = {
        enable = true;
        greeters.slick.enable = true;
      };
    };
    desktopManager.xfce.enable = true;
    layout = "us";
    xkbVariant = "";
  };
}
