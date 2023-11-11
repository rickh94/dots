{pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      todo-comments-nvim
    ];

    extraLuaConfig = /* lua */ ''
      require('todo-comments').setup()
      require('which-key').register({
        -- SEARCH AND TELESCOPE KEYBINDS
        s = {
          name = "+Search",
          t = { '<cmd>TodoTelescope<cr>', 'Search Todos' },
        },
      }, { prefix = '<leader>', mode = 'n' })
    '';

  };
}
