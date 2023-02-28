{ pkgs, ... }: 
{
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
    /* extraEnv = ''
      let-env EDITOR = "nvim"

      let-env PATH = ($env.PATH | append ".cargo/bin")
      let-env PATH = ($env.PATH | append ".local/bin")
    ''; */
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
