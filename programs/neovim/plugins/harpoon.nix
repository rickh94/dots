{ unstablePkgs, ... }:
{
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      harpoon
    ];

    extraLuaConfig = /* lua */ ''
      require('harpoon').setup({
        global_settings = {
          -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
          save_on_toggle = false,

          -- saves the harpoon file upon every change. disabling is unrecommended.
          save_on_change = true,

          -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
          enter_on_sendcmd = false,

          -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
          tmux_autoclose_windows = false,

          -- filetypes that you want to prevent from adding to the harpoon list menu.
          excluded_filetypes = { "harpoon" },

          -- set marks specific to each git branch inside git repository
          mark_branch = false,

          -- enable tabline with harpoon marks
          tabline = false,
          tabline_prefix = "   ",
          tabline_suffix = "   ",
        }
      })

      pcall(require('telescope').load_extension, 'harpoon')

      require('which-key').register({
        -- harpoon keybinds
        s = {
          h = { '<cmd>Telescope harpoon marks<cr>', 'Harpoon Marks' },
        },
        h = {
          name = "+Harpoon",
          a = { require("harpoon.mark").add_file, 'Add file to harpoon' },
          n = { require("harpoon.ui").nav_next, 'Next harpoon file' },
          p = { require("harpoon.ui").nav_prev, 'Previous harpoon file' },
        },
      }, { prefix = '<leader>', mode = 'n' })
    '';

  };
}
