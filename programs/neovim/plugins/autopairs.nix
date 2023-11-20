{ unstablePkgs, ... }:
{
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      nvim-autopairs
    ];

    extraLuaConfig = /* lua */ ''
      require('nvim-autopairs').setup({ })
    '';

  };
}
