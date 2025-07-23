{ unstablePkgs, ... }:
{
  home.packages = with unstablePkgs; [
    nil
    tailwindcss-language-server
    arduino-language-server
    astro-language-server
    docker-language-server
    gopls
    vscode-langservers-extracted
    just-lsp
    lua-language-server
    pyright
    ruff
    typescript-language-server
    zls
    biome
    superhtml
    yaml-language-server
    slint-lsp
    ty

  ];
  programs.helix.enable = true;
  programs.helix.package = unstablePkgs.helix;
  programs.helix.settings = {
    theme = "catppuccin_macchiato";
    editor = {
      line-number = "relative";
      cursorline = true;
      lsp = {
        display-inlay-hints = true;
      };
      cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
      indent-guides.render = true;
      inline-diagnostics = {
        cursor-line = "error";
        other-lines = "error";
      };
    };
  };
  programs.helix.languages = {
    language-server.biome = {
      command = "biome";
      args = [ "lsp-proxy" ];
    };
    language = [
      {
        name = "javascript";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = [ "format" ];
          }
          "biome"
        ];
        auto-format = true;
      }
      {
        name = "typescript";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = [ "format" ];
          }
          "biome"
        ];
        auto-format = true;
      }
      {
        name = "tsx";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = [ "format" ];
          }
          "biome"
        ];
        auto-format = true;
      }
      {
        name = "jsx";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = [ "format" ];
          }
          "biome"
        ];
        auto-format = true;
      }
      {
        name = "json";
        language-servers = [
          {
            name = "vscode-json-language-server";
            except-features = [ "format" ];
          }
          "biome"
        ];
        auto-format = true;
      }
    ];
  };
}
