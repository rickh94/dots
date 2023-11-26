{ unstablePkgs, ... }:
let
  guihua = unstablePkgs.vimUtils.buildVimPlugin {
    pname = "guihua";
    version = "HEAD";
    src = builtins.fetchGit {
      url = "https://github.com/ray-x/guihua.lua";
      ref = "HEAD";
    };
  };
in
{
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      go-nvim
      guihua
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require('go').setup()
      '';
  };
}
