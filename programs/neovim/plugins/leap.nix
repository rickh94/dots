{ unstablePkgs, ... }: {
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      leap-nvim
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require('leap').add_default_mappings()
      '';
  };
}
