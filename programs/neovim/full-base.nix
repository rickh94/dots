{ ... }: {
  imports = [
    ./default.nix
    ./plugins/aerial.nix
    ./plugins/conform.nix
    ./plugins/cyberdream.nix
    # ./plugins/gitsigns.nix
    ./plugins/go.nix
    ./plugins/guess-indent.nix
    ./plugins/lilypond.nix
    ./plugins/lint.nix
    ./plugins/lspimport.nix
    ./plugins/lsp.nix
    ./plugins/cmp.nix
    ./plugins/persistence.nix
    ./plugins/rainbow-delimiters.nix
    ./plugins/rust.nix
    ./plugins/sandwich.nix
    # ./plugins/surround.nix
    # ./plugins/sos.nix
    # ./plugins/tailwindcss-colors.nix
    ./plugins/telescope.nix
    ./plugins/todo-comments.nix
    ./plugins/treesitter.nix
    # ./plugins/undotree.nix
    ./plugins/vim-tmux-navigator.nix
    ./plugins/oil.nix
    # ./plugins/chatgpt.nix
    ./plugins/autopairs.nix
    ./plugins/gotempl.nix
    # ./plugins/nougat.nix
    ./plugins/spider.nix
    ./plugins/various-textobjs.nix
    # ./plugins/treesj.nix
    # ./plugins/trouble.nix
    # ./plugins/noice.nix
    ./plugins/indent-blankline.nix
  ];
}
