{ unstablePkgs, ... }: {
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      persistence-nvim
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require('persistence').setup({
          dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- directory where session files are saved
          options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
          pre_save = nil, -- a function to call before saving the session
          save_empty = false, -- don't save if there are no open file buffers
        })

        require('which-key').add({
          {
            mode = 'n',
            { '<leader>qs', function() require('persistence').load() end, desc = "Load Session for Directory" },
            { '<leader>ql', function() require('persistence').load({ last = true }) end, desc = "Load Last Session" },
            { '<leader>qd', function() require('persistence').load({ last = true }) end, desc = "Don't save session" },
          }
        })
      '';
  };
}
