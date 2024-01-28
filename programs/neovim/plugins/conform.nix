{ unstablePkgs
, lib
, ...
}:
let
  templ =
    unstablePkgs.buildGoModule
      {
        pname = "templ";
        version = "0.2.476";
        src = unstablePkgs.fetchFromGitHub {
          owner = "a-h";
          repo = "templ";
          rev = "v0.2.476";
          sha256 = "sha256-lgeVfe+9kUxN4XXL7ANiFxtmupZwDaiRFABJIAclyd8=";
        };

        vendorHash = "sha256-hbXKWWwrlv0w3SxMgPtDBpluvrbjDRGiJ/9QnRKlwCE=";
        subPackages = [ "cmd/templ" ];

        meta = with lib; {
          description = "Templates for go";
          homepage = "https://templ.guide";
          license = licenses.mit;
        };
      };
in
{
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
      sqlfluff
      templ
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
              },
              templfmt = {
                stdin = true,
                command = "${templ}/bin/templ",
                args = { "fmt" },
              },
              -- sqlfluff = {
              --   stdin = false,
              --   command ="${unstablePkgs.sqlfluff}/bin/sqlfluff",
              --   args = { "format", "$FILENAME" },
              -- },
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
              toml = { "taplo", },
              templ = { "rustywind", "templfmt" },
              -- sql = { "sqlfluff" },
              ["*"] = { "trim_whitespace" },
            },
          })

          require('which-key').register({
            f = { '<cmd>Format<cr>', 'Format' }
          }, { prefix = '<leader>', mode = 'n' })
      '';
  };
}
