{ pkgs, ... }: {
  text =
    /*
      lua
    */
    ''
      local wezterm = require 'wezterm'

      local config = {}

      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      -- config.font = wezterm.font('CaskaydiaCove Nerd Font Mono')
      config.default_prog = { '${pkgs.fish}/bin/fish', '-l' }
      config.window_background_opacity = 0.85
      config.font_size = 14
      config.macos_window_background_blur = 15
      -- config.line_height = 0.95
      config.window_frame = {
        inactive_titlebar_bg = '#353535',
        active_titlebar_bg = '#2b2042',
        inactive_titlebar_fg = '#cccccc',
        active_titlebar_fg = '#ffffff',
        inactive_titlebar_border_bottom = '#2b2042',
        active_titlebar_border_bottom = '#2b2042',
        button_fg = '#cccccc',
        button_bg = '#2b2042',
        button_hover_fg = '#ffffff',
        button_hover_bg = '#3b3052',
      }

      return config
    '';
}
