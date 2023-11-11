{ pkgs }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      undotree
    ];

    extraLuaConfig = /* lua */ ''
      require('which-key').register({
        -- NVIM TREE KEYBINDS
        u = { vim.cmd.UndotreeToggle, "Open Undo Tree" },
      }, { mode = 'n', prefix = '<leader>' })
    '';

  };
}
