{ config, pkgs, ... }:
{
  xdg.configFile."wezterm/wezterm.lua" = {
     text = ''
      local wezterm = require 'wezterm'

      local config = {}

      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.color_scheme = 'Tokyo Night'
      config.font = wezterm.font('CaskaydiaCove Nerd Font Mono')
      config.default_prog = { '${pkgs.fish}/bin/fish', '-l' }
      config.window_background_opacity = 0.85
      config.font_size = 14
      config.macos_window_background_blur = 20
      config.line_height = 0.95

      return config
    '';
  };

}
