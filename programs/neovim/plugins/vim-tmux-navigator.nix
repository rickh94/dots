{pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      vim-tmux-navigator
    ];

    extraLuaConfig = /* lua */ ''
      require('which-key').register({
        ['<C-k>'] = { '<cmd>TmuxNavigateUp<cr>', 'Window Up' },
        ['<C-j>'] = { '<cmd>TmuxNavigateDown<cr>', 'Window Down' },
        ['<C-h>'] = { '<cmd>TmuxNavigateLeft<cr>', 'Window Left' },
        ['<C-l>'] = { '<cmd>TmuxNavigateRight<cr>', 'Window Right' },
        ['<C-\\>'] = { '<cmd>TmuxNavigatePrevious<cr>', 'Window Right' },
      }, { mode = 'n' })

    '';

  };
}
