{ pkgs, ... }:
{
  programs.zellij.enable = true;

  xdg.configFile."zellij/config.kdl" = {
    text = ''
      default_shell "${pkgs.fish}/bin/fish"
      theme "molokai-dark"
      on_force_close "quit"

      themes {
          molokai-dark {
              fg 248 248 240
              bg 27 29 30
              black 0 0 0
              red 255 0 0
              green 0 140 0
              yellow 255 255 0
              blue 102 217 239
              magenta 174 129 255
              cyan 0 255 255
              white 255 255 255
              orange 253 151 31
          }

          catppuccin-mocha {
            bg "#585b70" // Surface2
            fg "#cdd6f4"
            red "#f38ba8"
            green "#a6e3a1"
            blue "#89b4fa"
            yellow "#f9e2af"
            magenta "#f5c2e7" // Pink
            orange "#fab387" // Peach
            cyan "#89dceb" // Sky
            black "#181825" // Mantle
            white "#cdd6f4"
          }
          tokyo-night-dark {
              fg 169 177 214
              bg 26 27 38
              black 56 62 90
              red 249 51 87
              green 158 206 106
              yellow 224 175 104
              blue 122 162 247
              magenta 187 154 247
              cyan 42 195 222
              white 192 202 245
              orange 255 158 100
          }
      }
    '';
  };
}
