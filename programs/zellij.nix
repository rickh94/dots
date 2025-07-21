{pkgs, ...}: {
  programs.zellij.enable = true;

  xdg.configFile."zellij/config.kdl" = {
    text = ''
      default_shell "${pkgs.fish}/bin/fish"

      theme "catppuccin-macchiato"
      load_plugins {
        https://github.com/fresh2dev/zellij-autolock/releases/download/0.2.2/zellij-autolock.wasm
      }
    '';
  };
}
