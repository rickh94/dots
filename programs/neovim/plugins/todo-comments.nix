{ unstablePkgs, ... }: {
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      todo-comments-nvim
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require('todo-comments').setup()
        require('which-key').add({
          mode = 'n',
          { '<leader>st', '<cmd>TodoTelescope<cr>', desc = "Search Todos"}
        })
      '';
  };
}
