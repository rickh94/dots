{ unstablePkgs, ... }:
{
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      go-nvim
      # guihua
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
