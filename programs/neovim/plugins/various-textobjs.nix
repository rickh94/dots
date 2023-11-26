{ unstablePkgs, ... }:
let
  nvim-various-textobjs = unstablePkgs.vimUtils.buildVimPlugin {
    pname = "nvim-various-textobjs";
    version = "HEAD";
    src = builtins.fetchGit {
      url = "https://github.com/chrisgrieser/nvim-various-textobjs";
      ref = "HEAD";
    };
  };
in
{
  programs.neovim = {
    plugins = [
      nvim-various-textobjs
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require("various-textobjs").setup({ useDefaultKeymaps = true })
      '';
  };
}
