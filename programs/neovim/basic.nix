{ pkgs
, inputs
, system
, lib
, ...
}: {
  imports = [
    ./default.nix
    ./plugins/colorscheme.nix
    ./plugins/comment.nix
    ./plugins/format.nix
    ./plugins/guess-indent.nix
    ./plugins/lint.nix
    ./plugins/lsp.nix
    ./plugins/cmp.nix
    # ./plugins/nvim-tree.nix
    ./plugins/rainbow-delimiters.nix
    ./plugins/sandwich.nix
    ./plugins/sos.nix
    ./plugins/tailwindcss-colors.nix
    ./plugins/telescope.nix
    ./plugins/todo-comments.nix
    ./plugins/treesitter.nix
    ./plugins/undotree.nix
    ./plugins/vim-tmux-navigator.nix
    ./plugins/oil.nix
    ./plugins/autopairs.nix
  ];
}
