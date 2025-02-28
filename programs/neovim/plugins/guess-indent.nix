{ unstablePkgs, ... }: {
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      guess-indent-nvim
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require('guess-indent').setup {}
      '';
  };
}
