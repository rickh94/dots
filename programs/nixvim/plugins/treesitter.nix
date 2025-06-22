{ pkgs, ... }: {
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        arduino
        astro
        bash
        c
        caddy
        cmake
        comment
        cpp
        css
        csv
        diff
        dockerfile
        eex
        elixir
        erlang
        fish
        git_config
        git_rebase
        gitattributes
        gitcommit
        gitignore
        go
        gosum
        gotmpl
        gowork
        graphql
        haskell
        heex
        html
        htmldjango
        ini
        java
        javascript
        jinja
        jinja_inline
        jsdoc
        json
        json5
        julia
        just
        kcl
        kconfig
        kdl
        latex
        llvm
        lua
        luadoc
        make
        markdown
        nginx
        nim
        nix
        nu
        objc
        ocaml
        pascal
        passwd
        perl
        php
        phpdoc
        powershell
        printf
        proto
        pug
        purescript
        python
        r
        regex
        requirements
        readline
        ron
        ruby
        rust
        scala
        sql
        ssh_config
        svelte
        sway
        swift
        tcl
        terraform
        tmux
        toml
        tsx
        typescript
        vim
        vimdoc
        vue
        xml
        yaml
        zig
      ];
      settings = {
        highlight.enable = true;
        indent.enable = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<c-space>";
            node_incremental = "<c-space>";
            scope_incremental = false;
            node_decremental = "<BS>";
          };
        };
      };
    };
    plugins.treesitter-textobjects = {
      enable = true;
      select = {
        enable = true;
        lookahead = true;
        keymaps = {
          "a=" = { query = "@assignment.outer"; };
          "i=" = { query = "@assignment.inner"; desc = "Select inner part of an assignment"; };

          "aa" = { query = "@parameter.outer"; desc = "Select outer part of a parameter/argument"; };
          "ia" = { query = "@parameter.inner"; desc = "Select inner part of a parameter/argument"; };

          "a:" = { query = "@property.outer"; desc = "Select outer part of an object property"; };
          "i:" = { query = "@property.inner"; desc = "Select inner part of an object property"; };

          "ai" = { query = "@conditional.outer"; desc = "Select outer part of a conditional"; };
          "ii" = { query = "@conditional.inner"; desc = "Select inner part of a conditional"; };

          "al" = { query = "@loop.outer"; desc = "Select outer part of a loop"; };
          "il" = { query = "@loop.inner"; desc = "Select inner part of a loop"; };

          "af" = { query = "@call.outer"; desc = "Select outer part of a function call"; };
          "if" = { query = "@call.inner"; desc = "Select inner part of a function call"; };

          "am" = { query = "@function.outer"; desc = "Select outer part of a method/function definition"; };
          "im" = { query = "@function.inner"; desc = "Select inner part of a method/function definition"; };
        };
      };

      move = {
        enable = true;
        setJumps = true;
        gotoNextStart = {
          "]f" = { query = "@call.outer"; desc = "Next function call start"; };
          "]m" = { query = "@function.outer"; desc = "Next method/function def start"; };
          "]c" = { query = "@class.outer"; desc = "Next class start"; };
          "]i" = { query = "@conditional.outer"; desc = "Next conditional start"; };
          "]l" = { query = "@loop.outer"; desc = "Next loop start"; };

          "]s" = { query = "@scope"; queryGroup = "locals"; desc = "Next scope"; };
          "]z" = { query = "@fold"; queryGroup = "folds"; desc = "Next fold"; };
        };
        gotoNextEnd = {
          "]M" = { query = "@function.outer"; desc = "Next method/function def end"; };
          "]C" = { query = "@class.outer"; desc = "Next class end"; };
          "]I" = { query = "@conditional.outer"; desc = "Next conditional end"; };
          "]L" = { query = "@loop.outer"; desc = "Next loop end"; };
        };
        gotoPreviousStart = {
          "[f" = { query = "@call.outer"; desc = "Prev function call start"; };
          "[m" = { query = "@function.outer"; desc = "Prev method/function def start"; };
          "[c" = { query = "@class.outer"; desc = "Prev class start"; };
          "[i" = { query = "@conditional.outer"; desc = "Prev conditional start"; };
          "[l" = { query = "@loop.outer"; desc = "Prev loop start"; };
        };
        gotoPreviousEnd = {
          "[F" = { query = "@call.outer"; desc = "Prev function call end"; };
          "[M" = { query = "@function.outer"; desc = "Prev method/function def end"; };
          "[C" = { query = "@class.outer"; desc = "Prev class end"; };
          "[I" = { query = "@conditional.outer"; desc = "Prev conditional end"; };
          "[L" = { query = "@loop.outer"; desc = "Prev loop end"; };
        };
      };
    };
    plugins.treesitter-refactor.enable = true;
  };
}
