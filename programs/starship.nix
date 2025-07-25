{...}: {
  programs.starship = {
    enable = true;
    enableNushellIntegration = false;
    settings = {
      # format = lib.concatStrings [
      #   "$username"
      #   "$hostname"
      #   "$directory"
      #   "$git_branch"
      #   "$git_state"
      #   "$git_status"
      #   "$cmd_duration"
      #   "$elixir"
      #   "$nodejs"
      #   "$lua"
      #   "$rust"
      #   "$java"
      #   "$jobs"
      #   "$sudo"
      #   "$python"
      #   "$line_break"
      #   "$nix_shell"
      #   "$character"
      # ];

      command_timeout = 1200;

      # directory = {
      #   style = "blue bold";
      # };
      #
      # character = {
      #   success_symbol = "[❯](purple)";
      #   error_symbol = "[❯](red)";
      #   vimcmd_symbol = "[❮](green)";
      # };
      #
      # git_branch = {
      #   format = "[$branch]($style)";
      #   style = "bright-pink";
      # };
      #
      # git_status = {
      #   format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
      #   style = "cyan";
      #   conflicted = "​";
      #   untracked = "​";
      #   modified = "​";
      #   staged = "​";
      #   renamed = "​";
      #   deleted = "​";
      #   stashed = "≡";
      # };
    };
  };
}
