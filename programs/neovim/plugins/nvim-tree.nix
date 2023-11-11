{ unstablePkgs, ... }:
{
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      nvim-tree-lua
    ];

    extraLuaConfig = /* lua */ ''
      require('nvim-tree').setup()
      require('which-key').register({
        -- NVIM TREE KEYBINDS
        e = { '<cmd>NvimTreeToggle<cr>', 'Open/close file tree' },
        o = { '<cmd>NvimTreeFocus<cr>', 'Focus file tree' },
      }, { mode = 'n', prefix = '<leader>' })
    '';

  };
}
