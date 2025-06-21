{ unstablePkgs, ... }:
{
  programs.neovim = {
    plugins = [
      unstablePkgs.vimPlugins.nvim-various-textobjs
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require("various-textobjs").setup({ keymaps = { useDefaults = true }})
      '';
  };
}
