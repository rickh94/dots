{ pkgs, inputs, system, ... }:
{
  xdg.configFile."nvim/init.lua" = {
     source = ./neovim/init.lua;
#    text = ''
#    '';
  };


  programs.neovim = {
      enable = true;
      defaultEditor = true;
#     plugins = with pkgs.vimPlugins; [
#       codeium-nvim
#       plenary-nvim
#       vim-fugitive
#       vim-rhubarb
#        guess-indent-nvim
#       vim-repeat
#       undotree
#       mkdir-nvim
#       comment-nvim
#       which-key-nvim
#       telescope-nvim
#       telescope-fzf-native-nvim
#       nvim-treesitter
#       nvim-treesitter-textobjects
#       nvim-treesitter-context
#       nvim-lspconfig
#       mason-nvim
#       mason-lspconfig-nvim
#       neodev-nvim
#       lspkind-nvim
#       nvim-cmp
#       cmp-nvim-lsp
#       luasnip
#       cmp_luasnip
#       cmp-buffer
#       cmp-path
#       cmp-cmdline
#       cmp-rg
#       friendly-snippets
#       nvim-autopairs
#       vim-sandwich
#       gitsigns-nvim
#       lualine-nvim
#       vim-dadbod
#       rust-tools-nvim
#       lsp-inlayhints-nvim
#       crates-nvim
#       nvim-ts-autotag
#       go-nvim
#       vim-css-color
#       tokyonight-nvim
#       #dashboard-nvim
#       dressing-nvim
#       todo-comments-nvim
#       null-ls-nvim
#     ];
    };
}
