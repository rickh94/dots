{ unstablePkgs, ... }: {
  home.packages = with unstablePkgs; [
    elixir-ls
  ];
  programs.nixvim = {
    extraPlugins = [
      unstablePkgs.vimPlugins.elixir-tools-nvim
    ];

    extraConfigLua =
      /*
      lua
      */
      ''
        require("elixir").setup({
          nextls = {
            enable = false,
          },
          elixirls = {
            enable = true,
            cmd = "${unstablePkgs.elixir-ls}/bin/elixir-ls"
          },
          projectionist = {enable = false},
        })
      '';
  };
}
