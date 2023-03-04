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
      text = ''
        let-env config = ($env | default {} config).config
        let-env config = ($env.config | default {} hooks)
        let-env config = ($env.config | update hooks ($env.config.hooks | default {} env_change))
        let-env config = ($env.config | update hooks.env_change ($env.config.hooks.env_change | default [] PWD))
        let-env config = ($env.config | update hooks.env_change.PWD ($env.config.hooks.env_change.PWD | append {|_, dir|
          zoxide add -- $dir
        }))

        def-env __zoxide_z [...rest:string] {
          let arg0 = ($rest | append '~').0
          let path = if (($rest | length) <= 1) && ($arg0 == '-' || ($arg0 | path expand | path type) == dir) {
            $arg0
          } else {
            (${pkgs.zoxide}/bin/zoxide query --exclude $env.PWD -- $rest | str trim -r -c "\n")
          }
          cd $path
        }

        def-env __zoxide_zi  [...rest:string] {
          cd $'(${pkgs.zoxide}/bin/zoxide query -i -- $rest | str trim -r -c "\n")'
        }

        alias z = __zoxide_z
        alias zi = __zoxide_zi
      '';
      # source = ./zoxide.nu;
    };
    ".cache/starship/init.nu" = {
      # source = ./starship-init.nu;
      text = ''

          let-env STARSHIP_SHELL = "nu"
          let-env STARSHIP_SESSION_KEY = (random chars -l 16)
          let-env PROMPT_MULTILINE_INDICATOR = (${pkgs.starship}/bin/starship prompt --continuation)

          let-env PROMPT_INDICATOR = ""
          let-env PROMPT_INDICATOR_VI_NORMAL = ""
          let-env PROMPT_INDICATOR_VI_INSERT = ""

          let-env PROMPT_COMMAND = {
              # jobs are not supported
              let width = ((term size).columns | into string)
              ${pkgs.starship}/bin/starship prompt $"--cmd-duration=($env.CMD_DURATION_MS)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=($width)"
          }

          let-env PROMPT_COMMAND_RIGHT = {""}
        '';
    };
  };
}
