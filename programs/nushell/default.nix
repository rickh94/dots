{ pkgs, ... }: 
{
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
  };

  home.file = {
    ".zoxide.nu" = {
      source = ./zoxide.nu;
    };
    ".cache/starship/init.nu" = {
        source = ./starship-init.nu;
    };
  };
}
