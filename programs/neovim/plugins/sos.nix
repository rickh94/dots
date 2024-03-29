{ unstablePkgs, ... }:
let
  sos-nvim = unstablePkgs.vimUtils.buildVimPlugin {
    pname = "sos-nvim";
    version = "HEAD";
    src = builtins.fetchGit {
      url = "https://github.com/tmillr/sos.nvim";
      ref = "HEAD";
    };
  };
in
{
  programs.neovim = {
    plugins = [
      sos-nvim
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
