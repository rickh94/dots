{ unstablePkgs, ... }: {
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      comment-nvim
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require('Comment').setup()
      '';
  };
}
