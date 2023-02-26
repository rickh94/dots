let-env STARSHIP_SHELL = "nu"
let-env STARSHIP_SESSION_KEY = (random chars -l 16)
let-env PROMPT_MULTILINE_INDICATOR = (^/nix/store/451pnrysaah2k63ds32w457va7k40pjh-starship-1.11.0/bin/starship prompt --continuation)

let-env PROMPT_INDICATOR = ''
let-env PROMPT_INDICATOR_VI_NORMAL = ""
let-env PROMPT_INDICATOR_VI_INSERT = ""

let-env PROMPT_COMMAND = {
    # jobs are not supported
    let width = ((term size).columns | into string)
    ^/nix/store/451pnrysaah2k63ds32w457va7k40pjh-starship-1.11.0/bin/starship prompt $"--cmd-duration=($env.CMD_DURATION_MS)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=($width)"
}

let-env PROMPT_COMMAND_RIGHT = {''}
