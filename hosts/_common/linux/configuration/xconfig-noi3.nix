{ pkgs, ... }: {
  displayManager.defaultSesson = "xfce";
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm = {
        enable = true;
        greeters.slick.enable = true;
      };
    };
    desktopManager.xfce.enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };
}
