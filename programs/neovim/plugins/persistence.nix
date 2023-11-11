{ unstablePkgs, ... }:
{
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      persistence-nvim
    ];

    extraLuaConfig = /* lua */ ''
      require('persistence').setup({
        dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- directory where session files are saved
        options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
        pre_save = nil, -- a function to call before saving the session
        save_empty = false, -- don't save if there are no open file buffers 
      })

      require('which-key').register({
        q = {
          name = "+Session",
          s = { function() require('persistence').load() end, "Load Session for Directory" },
          l = { function() require('persistence').load({ last = true }) end, "Load Last Session" },
          d = { function() require('persistence').top() end, "Don't save session" },
        },
      }, { prefix = '<leader>', mode = 'n' })
    '';

  };
}
