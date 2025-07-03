{ unstablePkgs, ... }: {
  home.packages = with unstablePkgs; [
    next-ls
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
            cmd = "${unstablePkgs.next-ls}/bin/next-ls"
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
