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
      (plugin "tmillr/sos.nvim")
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require('sos').setup({
            enabled = true,
            timeout = 20000,
            autowrite = true,
            save_on_cmd = "some",
            save_on_bufleave = false,
            save_on_focuslost = true,
          })
      '';
  };
}
