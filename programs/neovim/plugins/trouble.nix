{ unstablePkgs, ... }: {
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      trouble-nvim
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require('trouble').setup()
        require('which-key').register({
          ['<leader>xx'] = { '<cmd>TroubleToggle<cr>', 'Trouble' },
          ['<leader>xw'] = { '<cmd>TroubleToggle workspace_diagnostics<cr>', 'Workspace Diagnostics' },
          ['<leader>xd'] = { '<cmd>TroubleToggle document_diagnostics<cr>', 'Document Diagnostics' },
          ['<leader>xq'] = { '<cmd>TroubleToggle quickfix<cr>', 'Quickfix' },
          ['<leader>xl'] = { '<cmd>TroubleToggle loclist<cr>', 'Location List' },
          ['gR'] = { '<cmd>TroubleToggle lsp_references<cr>', 'LSP References' },
        }, { mode = 'n' })
      '';
  };
}
