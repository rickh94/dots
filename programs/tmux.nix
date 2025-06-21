{ pkgs
, lib
, ...
}:
let
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
    tmuxp.enable = true;
    escapeTime = 0;
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank
      tmuxPlugins.catppuccin
      tmuxPlugins.resurrect
      tmuxPlugins.tmux-fzf
      tmuxPlugins.sessionist
      tmuxPlugins.continuum
      tmuxPlugins.mode-indicator
      tmuxPlugins.open
      #tmux-open-nvim
    ];
    terminal = "tmux-256color";
    extraConfig =
      /*
      bash
      */
      ''
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

        set -g @continuum-restore 'on'

        set -g @suspend_key 'F10'

      '';
  };
}
