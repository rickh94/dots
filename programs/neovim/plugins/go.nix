{ unstablePkgs, ... }:
{
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      go-nvim
    ];

    extraLuaConfig = /* lua */ ''
      require('go').setup()
    '';

  };
}
