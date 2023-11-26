{ unstablePkgs, ... }: {
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      nvim-surround
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require('nvim-surround').setup()
      '';
  };
}
