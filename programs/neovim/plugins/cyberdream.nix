{ pkgs, ... }: {
  programs.neovim = {
    plugins = [
      pkgs.vimPlugins.cyberdream-nvim
    ];
    extraPackages = [
    ];
    extraLuaConfig =
      /*
      lua
      */
      ''
        require("cyberdream").setup({
            -- Recommended - see "Configuring" below for more config options
            transparent = true,
            italic_comments = true,
            hide_fillchars = true,
            borderless_pickers = false,
            highlights = {
              LineNr = { fg = "#5ea1ff" },
              CursorLineNr = { fg = "#5ef1ff" },
            }
        })
        vim.cmd.colorscheme("cyberdream") -- set the colorscheme
      '';
  };
}
