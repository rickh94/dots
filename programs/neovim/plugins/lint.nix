{ unstablePkgs
, lib
, pkgs
, config
, ...
}: {
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins; [
      nvim-lint
    ];

    extraPackages = with unstablePkgs; [
      mypy
      ruff
      stylelint
      php83Packages.php-cs-fixer
      nodePackages.jsonlint
      nodePackages.alex
      codespell
      actionlint
      djlint
      vale
      yamllint
      write-good
      bandit
      sqlfluff
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require('lint').linters_by_ft = {
          css = {
            'stylelint'
          },
          htmldjango = {
            'djlint', 'curlylint',
          },
          json = {
            'jsonlint',
          },
          markdown = {
            'vale',
          },
          sql = {
            'sqlfluff',
          },
          ['*'] = {
            'codespell', 'alex', 'proselint', 'write-good'
          }
        }

        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          callback = function()
            require("lint").try_lint()
          end,
        })
      '';
  };

  home.activation.install-linters = lib.hm.dag.entryAfter [ "installPackages" ] ''
    export PATH="$PATH:${pkgs.nodejs}/bin:${unstablePkgs.gnutar}/bin:${unstablePkgs.gzip}/bin"
    ${config.programs.neovim.finalPackage}/bin/nvim --headless +"MasonInstall ruff mypy stylelint php-cs-fixer jsonlint alex codespell curlylint actionlint djlint vale yamllint write-good yamllint sqlfluff" +qall
    ${config.programs.neovim.finalPackage}/bin/nvim --headless +"MasonUpdate" +qall
  '';
}
