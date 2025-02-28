{ unstablePkgs, lib, ... }:
{
  programs.neovim = {
    plugins = with unstablePkgs.vimPlugins;
      [
        nvim-lint
      ];

    extraPackages = with unstablePkgs; [
      mypy
      stylelint
      php83Packages.php-cs-fixer
      nodePackages.jsonlint
      codespell
      actionlint
      djlint
      yamllint
      write-good
      bandit
      sqlfluff
      golangci-lint
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
            'djlint', 'codespell'
          },
          json = {
            'jsonlint',
          },
          sql = {
            'sqlfluff',
          },
          html = {
            'codespell', 'proselint'
          },
          markdown = {
            'codespell', 'proselint'
          },
          txt = {
            'codespell', 'proselint'
          },
        }

        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          callback = function()
            require("lint").try_lint()
          end,
        })
      '';
  };

  # home.activation.install-linters = lib.hm.dag.entryAfter [ "installPackages" ] ''
  #   export PATH="$PATH:${pkgs.nodejs}/bin:${unstablePkgs.gnutar}/bin:${unstablePkgs.gzip}/bin"
  #   ${config.programs.neovim.finalPackage}/bin/nvim --headless +"MasonInstall ruff mypy stylelint php-cs-fixer jsonlint codespell curlylint actionlint djlint yamllint write-good yamllint sqlfluff" +qall
  #   ${config.programs.neovim.finalPackage}/bin/nvim --headless +"MasonUpdate" +qall
  # '';
}
