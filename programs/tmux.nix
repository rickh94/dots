{ pkgs, lib, ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    historyLimit = 10000;
    shell = "${pkgs.nushell}/bin/nu";
    extraConfig = lib.strings.concatStringsSep "\n" [
      "tmux_conf_new_window_retain_current_path=true"
      "tmux_conf_new_pane_retain_current_path=true"
      "tmux_conf_new_pane_reconnect_ssh=false"
      "tmux_conf_new_session_prompt=false"
      "tmux_conf_theme_24b_colour=false"
      "tmux_conf_theme_window_fg='default'"
      "tmux_conf_theme_window_bg='default'"
      "tmux_conf_theme_highlight_focused_pane=false"
      "tmux_conf_theme_focused_pane_fg='default'"
      "tmux_conf_theme_focused_pane_bg='#0087d7'               # light blue"
      "tmux_conf_theme_pane_border_style=thin"
      "tmux_conf_theme_pane_border='#444444'                   # gray"
      "tmux_conf_theme_pane_active_border='#00afff'            # light blue"
      "tmux_conf_theme_pane_indicator='#00afff'                # light blue"
      "tmux_conf_theme_pane_active_indicator='#00afff'         # light blue"
      "tmux_conf_theme_message_fg='#000000'                    # black"
      "tmux_conf_theme_message_bg='#ffff00'                    # yellow"
      "tmux_conf_theme_message_attr='bold'"
      "tmux_conf_theme_message_command_fg='#ffff00'            # yellow"
      "tmux_conf_theme_message_command_bg='#000000'            # black"
      "tmux_conf_theme_message_command_attr='bold'"
      "tmux_conf_theme_mode_fg='#000000'                       # black"
      "tmux_conf_theme_mode_bg='#ffff00'                       # yellow"
      "tmux_conf_theme_mode_attr='bold'"
      "tmux_conf_theme_status_fg='#8a8a8a'                     # light gray"
      "tmux_conf_theme_status_bg='#080808'                     # dark gray"
      "tmux_conf_theme_status_attr='none'"
      "tmux_conf_theme_window_status_fg='#8a8a8a'              # light gray"
      "tmux_conf_theme_window_status_bg='#080808'              # dark gray"
      "tmux_conf_theme_window_status_attr='none'"
      "tmux_conf_theme_window_status_format='#I #W#{?window_bell_flag,🔔,}#{?window_zoomed_flag,🔍,}'"
      "tmux_conf_theme_window_status_current_fg='#000000'      # black"
      "tmux_conf_theme_window_status_current_bg='#00afff'      # light blue"
      "tmux_conf_theme_window_status_current_attr='bold'"
      "tmux_conf_theme_window_status_current_format='#I #W#{?window_zoomed_flag,🔍,}'"
      "tmux_conf_theme_window_status_activity_fg='default'"
      "tmux_conf_theme_window_status_activity_bg='default'"
      "tmux_conf_theme_window_status_activity_attr='underscore'"
      "tmux_conf_theme_window_status_bell_fg='#ffff00'         # yellow"
      "tmux_conf_theme_window_status_bell_bg='default'"
      "tmux_conf_theme_window_status_bell_attr='blink,bold'"
      "tmux_conf_theme_window_status_last_fg='#00afff'         # light blue"
      "tmux_conf_theme_window_status_last_bg='default'"
      "tmux_conf_theme_window_status_last_attr='none'"
      "tmux_conf_theme_left_separator_main=''  # /!\ you don't need to install Powerline"
      "tmux_conf_theme_left_separator_sub=''   #   you only need fonts patched with"
      "tmux_conf_theme_right_separator_main='' #   Powerline symbols or the standalone"
      "tmux_conf_theme_right_separator_sub=''  #   PowerlineSymbols.otf font"
      "tmux_conf_theme_status_left=' ❐ #S | ↑#{?uptime_d, #{uptime_d}d,}#{?uptime_h, #{uptime_h}h,}#{?uptime_m, #{uptime_m}m,} '"
      "tmux_conf_theme_status_right='#{prefix}#{pairing} #{?battery_status, #{battery_status},}#{?battery_bar, #{battery_bar},}#{?battery_percentage, #{battery_percentage},} , %R , %d %b | #{username}#{root} | #{hostname} '"
      "tmux_conf_theme_status_left_fg='#000000,#e4e4e4,#e4e4e4'  # black, white , white"
      "tmux_conf_theme_status_left_bg='#ffff00,#ff00af,#00afff'  # yellow, pink, white blue"
      "tmux_conf_theme_status_left_attr='bold,none,none'"
      "tmux_conf_theme_status_right_fg='#8a8a8a,#e4e4e4,#000000' # light gray, white, black"
      "tmux_conf_theme_status_right_bg='#080808,#d70000,#e4e4e4' # dark gray, red, white"
      "tmux_conf_theme_status_right_attr='none,none,bold'"
      "tmux_conf_theme_pairing='👓 '          # U+1F453"
      "tmux_conf_theme_pairing_fg='none'"
      "tmux_conf_theme_pairing_bg='none'"
      "tmux_conf_theme_pairing_attr='none'"
      "tmux_conf_theme_prefix='⌨ '            # U+2328"
      "tmux_conf_theme_prefix_fg='none'"
      "tmux_conf_theme_prefix_bg='none'"
      "tmux_conf_theme_prefix_attr='none'"
      "tmux_conf_theme_root='!'"
      "tmux_conf_theme_root_fg='none'"
      "tmux_conf_theme_root_bg='none'"
      "tmux_conf_theme_root_attr='bold,blink'"
      "tmux_conf_battery_bar_symbol_full='◼'"
      "tmux_conf_battery_bar_symbol_empty='◻'"
      "tmux_conf_battery_bar_length='auto'"
      "tmux_conf_battery_bar_palette='gradient'"
      "tmux_conf_battery_hbar_palette='gradient'"
      "tmux_conf_battery_vbar_palette='gradient'"
      "tmux_conf_battery_status_charging='↑'       # U+2191"
      "tmux_conf_battery_status_discharging='↓'    # U+2193"
      "tmux_conf_theme_clock_colour='#00afff'  # light blue"
      "tmux_conf_theme_clock_style='24'"
      "tmux_conf_copy_to_os_clipboard=true"
    ];
  };

}
