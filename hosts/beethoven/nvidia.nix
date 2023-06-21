{ lib, ... }:
{

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.config = lib.mkAfter ''
    Section "InputClass"
    Identifier "MX Master Acceleration"
    MatchDriver "libinput"
    MatchProduct "MX Master"
    Option "AccelSpeed" "-0.6"
    EndSection
  '';
  services.xserver.screenSection = ''
    Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
  '';
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;
}
