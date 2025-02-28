{ unstablePkgs, ... }: {
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      vim-tmux-navigator
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require('which-key').add({
          mode = 'n',
          {'<C-k>', '<cmd>TmuxNavigateUp<cr>', desc = 'Window Up' },
          {'<C-j>', '<cmd>TmuxNavigateDown<cr>', desc = 'Window Down' },
          {'<C-h>', '<cmd>TmuxNavigateLeft<cr>', desc = 'Window Left' },
          {'<C-l>', '<cmd>TmuxNavigateRight<cr>', desc = 'Window Right' },
        })

      '';
  };
}
