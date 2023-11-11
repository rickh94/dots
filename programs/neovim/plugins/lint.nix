{pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      nvim-lint
    ];

    extraLuaConfig = /* lua */ ''
      require('lint').linters.flake8 = {
        cmd = "pflake8"
      }
      require('lint').linters_by_ft = {
        python = {
          'flake8', 'mypy', 'vulture'
        },
        css = {
          'stylelint'
        },
        php = {
          'phpcs',
        },
        htmldjango = {
          'djlint', 'curlylint'
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
      }
    '';

  };
}
