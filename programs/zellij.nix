{pkgs, ...}: {
  programs.zellij.enable = true;

  xdg.configFile."zellij/config.kdl" = {
    text = ''
      default_shell "${pkgs.fish}/bin/fish"

      theme "catppuccin-macchiato"
      load_plugins {
        https://github.com/fresh2dev/zellij-autolock/releases/download/0.2.2/zellij-autolock.wasm
      }
      keybinds {
          shared_except "locked" {
              bind "Ctrl h" {
                  MessagePlugin "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm" {
                      name "move_focus_or_tab";
                      payload "left";

                      // Plugin Configuration
                      move_mod "ctrl"; // Optional, should be added on every move command if changed.
                      use_arrow_keys "false"; // Optional, uses arrow keys instead of hjkl. Should be added to every command where you want to use it.
                  };
              }

              bind "Ctrl j" {
                  MessagePlugin "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm" {
                      name "move_focus";
                      payload "down";

                      move_mod "ctrl";
                      use_arrow_keys "false";
                  };
              }

              bind "Ctrl k" {
                  MessagePlugin "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm" {
                      name "move_focus";
                      payload "up";

                      move_mod "ctrl";
                      use_arrow_keys "false";
                  };
              }

              bind "Ctrl l" {
                  MessagePlugin "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm" {
                      name "move_focus_or_tab";
                      payload "right";

                      move_mod "ctrl"; // Optional, should be added on every command if you want to use it
                      use_arrow_keys "false";
                  };
              }

              bind "Alt h" {
                  MessagePlugin "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm" {
                      name "resize";
                      payload "left";

                      resize_mod "alt";
                  };
              }

              bind "Alt j" {
                  MessagePlugin "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm" {
                      name "resize";
                      payload "down";

                      resize_mod "alt";
                  };
              }

              bind "Alt k" {
                  MessagePlugin "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm" {
                      name "resize";
                      payload "up";

                      resize_mod "alt";
                  };
              }

              bind "Alt l" {
                  MessagePlugin "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm" {
                      name "resize";
                      payload "right";

                      resize_mod "alt";
                  };
              }
          }
      }
    '';
  };
}
