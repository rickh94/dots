{ unstablePkgs, ... }:
{
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      rainbow-delimiters-nvim
    ];

    extraLuaConfig = /* lua */ ''
      require('rainbow-delimiters.setup').setup()
    '';

  };
}
