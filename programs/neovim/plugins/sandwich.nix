{ unstablePkgs, ... }:
{
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      vim-sandwich
    ];

  };
}
