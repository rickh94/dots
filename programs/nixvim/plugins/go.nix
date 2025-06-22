{ unstablePkgs, ... }: {
  programs.nixvim = {
    extraPlugins = with unstablePkgs.vimPlugins; [
      go-nvim
    ];

    extraConfigLua = /* lua */ ''
      require('go').setup();
    '';
  };
}
