{ pkgs, ... }:
{
  services.polybar = {
    enable = true;
    script = "${pkgs.polybar}/bin/polybar &";
  };
}
