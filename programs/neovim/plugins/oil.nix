{ unstablePkgs, ... }:
{
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      oil-nvim
    ];

    extraLuaConfig = /* lua */ ''
      require('oil').setup()
      require('which-key').register({
        -- NVIM TREE KEYBINDS
        ['-'] = { '<cmd>Oil<cr>', 'Open Parent Directory' },
      }, { mode = 'n',  })
    '';

  };
}
