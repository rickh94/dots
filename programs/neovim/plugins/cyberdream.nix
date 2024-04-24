{ unstablePkgs, ... }:
let
  cyberdream-nvim = unstablePkgs.vimUtils.buildVimPlugin {
    pname = "cyberdream-nvim";
    version = "HEAD";
    src = builtins.fetchGit {
      url = "https://github.com/scottmckendry/cyberdream.nvim";
      ref = "HEAD";
    };
  };
in
{
  programs.neovim = {
    plugins = [
      cyberdream-nvim
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
            borderless_telescope = true,
            theme = {
              highlights = {
                LineNr = { fg = "#5ea1ff" },
                CursorLineNr = { fg = "#5ef1ff" },
              },
            }
        })
        vim.cmd.colorscheme("cyberdream") -- set the colorscheme
      '';
  };
}
