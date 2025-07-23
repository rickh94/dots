{pkgs, ...}: {
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

      config.color_scheme = 'Catppuccin Macchiato'

      -- config.font = wezterm.font('CaskaydiaCove Nerd Font Mono')
      config.default_prog = { '${pkgs.fish}/bin/fish', '-l' }
      -- config.window_background_opacity = 0.85
      config.font_size = 14
      -- config.macos_window_background_blur = 15
      -- config.line_height = 0.95
      config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
      config.use_fancy_tab_bar = true


      -- This function returns the suggested title for a tab.
      -- It prefers the title that was set via `tab:set_title()`
      -- or `wezterm cli set-tab-title`, but falls back to the
      -- title of the active pane in that tab.
      function tab_title(tab_info)
        local title = tab_info.tab_title
        -- if the tab title is explicitly set, take that
        if title and #title > 0 then
          return title
        end
        -- Otherwise, use the title from the active pane
        -- in that tab
        return tab_info.active_pane.title
      end

      wezterm.on(
        'format-tab-title',
        function(tab, tabs, panes, config, hover, max_width)
          local title = tab_title(tab)
          if tab.is_active then
            return {
              { Background = { Color = '#1e2030' } },
              { Foreground = { Color = '#cad3f5' } },
              { Text = ' ' .. title .. ' ' },
            }
          end
          return {
            { Background = { Color = '#363a4f'}},
            { Foreground = { Color = '#cad3f5' } },
            { Text = ' ' .. title .. ' ' }
          }
        end
      )

      config.window_frame = {
        inactive_titlebar_bg = '#6e738d',
        active_titlebar_bg = '#b7bdf8',
        button_fg = '#cccccc',
        button_bg = '#2b2042',
        button_hover_fg = '#ffffff',
        button_hover_bg = '#3b3052',
        border_left_width = '0.5cell',
        border_right_width = '0.5cell',
        border_bottom_height = '0.25cell',
        border_top_height = '0.25cell',
        border_left_color = '#b7bdf8',
        border_right_color = '#b7bdf8',
        border_bottom_color = '#b7bdf8',
        border_top_color = '#b7bdf8',
      }

      return config
    '';
}
