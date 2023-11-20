{
  unstablePkgs,
  lib,
  ...
}: let
  pluginGit = ref: repo:
    unstablePkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
      };
    };

  # always installs latest version
  plugin = pluginGit "HEAD";
in {
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      (plugin "themaxmarchuk/tailwindcss-colors.nvim")
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require('tailwindcss-colors').setup()
      '';
  };
}
