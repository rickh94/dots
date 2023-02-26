# Nushell Environment Config File

#def create_left_prompt [] {
#    let path_segment = if (is-admin) {
#        $"(ansi red_bold)($env.PWD)"
#    } else {
#        $"(ansi green_bold)($env.PWD)"
#    }

#    $path_segment
#}

#def create_right_prompt [] {
#    let time_segment = ([
#        (date now | date format '%m/%d/%Y %r')
#    ] | str join)
#
#    $time_segment
#}

# Use nushell functions to define your right and left prompt

let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
}

let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

#let-env EDITOR = "nvim"

