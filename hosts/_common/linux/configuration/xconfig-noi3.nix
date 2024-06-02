{ pkgs, ... }: {
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
    xkb.layout = "us";
    xkb.variant = "";
  };
}
