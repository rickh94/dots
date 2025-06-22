{ pkgs
, devenv
, ...
}: {
  imports = [
    ./default.nix
  ];
  home.packages = with pkgs; [

    devenv.packages.${pkgs.system}.devenv
    vscodium
  ];
  programs.bash.enable = true;

  home.file."Wallpapers/wallpapers.txt" = {
    enable = true;
    source = ../../wallpapers/wallpapers.txt;
    onChange = ''
      #!/usr/bin/env bash
      cd $HOME/Wallpapers
      ${pkgs.wget}/bin/wget -nc -i wallpapers.txt
    '';
  };
}
