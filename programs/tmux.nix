{ pkgs, lib, ... }:
let
  # tmux-pomodoro-plus = pkgs.tmuxPlugins.mkTmuxPlugin {
  #   pluginName = "pomodoro";
  #   version = "1.0";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "olimorris";
  #     repo = "tmux-pomodoro-plus";
  #     rev = "565d039b3b138e3add82cf67a56d01eeb975cf43";
  #     sha256 = "sha256-bMPdLCj5emDC1iqKU3VIZpF8tbHqALrCHUHvuf+AuHY=";
  #   };
  #   postInstall = ''
  #     sed -e 's:CURRENT_DIR=.*$:CURRENT_DIR=\$\{TMUX_TMPDIR\}:g' -i $target/pomodoro.tmux
  #   '';
  # };
  tmux-open-nvim = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux_open_nvim";
    version = "1.0";
    src = pkgs.fetchFromGitHub {
      owner = "trevarj";
      repo = "tmux-open-nvim";
      rev = "41d26de2044095b59b69bfc2bb82f1f7c51f8a84";
      sha256 = "sha256-QrNzKet9eE8do9F2OPG09+LnHVwg/KIojxpATZsFR8c=";
    };
    # postInstall = ''
    #   sed -e 's:CURRENT_DIR=.*$:CURRENT_DIR=\$\{TMUX_TMPDIR\}:g' -i $target/pomodoro.tmux
    # '';
  };
in
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    historyLimit = 10000;
    shortcut = "b";
    mouse = true;
    shell = "${pkgs.fish}/bin/fish";
    baseIndex = 1;
    escapeTime = 0;
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank
      tmuxPlugins.catppuccin
      tmuxPlugins.resurrect
      tmuxPlugins.tmux-fzf
      tmuxPlugins.sessionist
      tmuxPlugins.continuum
      # {
      #   plugin = tmuxPlugins.cpu;
      #   extraConfig = ''
      #     set -g status-right '#{cpu_bg_color} CPU: #{cpu_icon} #{cpu_percentage} | %Y-%m-%d %H:%M #{tmux_mode_indicator}'
      #   '';
      # }
      tmuxPlugins.mode-indicator
      tmuxPlugins.open
      tmux-open-nvim
      # tmux-pomodoro-plus
    ];
    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"

      # Vim style pane selection
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Start windows and panes at 1, not 0
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Use Alt-arrow keys without prefix key to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Split panes more intuitively
      unbind %
      bind | split-window -h

      unbind '"'
      bind - split-window -v

      set-option -g status-position top
      set-option -g default-command "${pkgs.fish}/bin/fish"

        
    '';
  };

}

