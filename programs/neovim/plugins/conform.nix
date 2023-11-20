{ unstablePkgs, ... }: {
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      conform-nvim
    ];

    extraPackages = with unstablePkgs; [
      alejandra
      black
      djlint
      isort
      php83Packages.php-cs-fixer
      nodePackages.prettier
      rustywind
      taplo
      python311Packages.mdformat
      nixpkgs-fmt
      stylelint
      yamlfmt
      gawk
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require('conform').setup({
            format_on_save = {
              timeout_ms = 500,
              lsp_fallback = true,
            },
            format_after_save = {
              lsp_fallback = true,
            },
            formatters = {
              isort = {
                prepend_args = { "--profile", "black", },
              }
            },
            formatters_by_ft = {
              nix = { "alejandra", "nixpkgs_fmt" },
              python = { "black", "isort" },
              htmldjango = { "djlint", "rustywind" },
              jinja = { "djlint", "rustywind" },
              twig = { "djlint", "rustywind" },
              fish = { "fish_indent" },
              php = { "php_cs_fixer" },
              json = { "prettier", },
              yaml = { "yamlfmt", },
              javascript = { "prettier", "rustywind" },
              typescript = { "prettier", "rustywind" },
              javascriptreact = { "prettier" },
              typescriptreact = { "prettier" },
              html = { "prettier", "rustywind", },
              css = { "prettier", "stylelint" },
              markdown = { "mdformat", },
              toml = { "taplo", },
              templ = { "rustywind" },
              ["*"] = { "trim_whitespace" },
            },
          })

          require('which-key').register({
            f = { '<cmd>Format<cr>', 'Format' }
          }, { prefix = '<leader>', mode = 'n' })
      '';
  };
}
