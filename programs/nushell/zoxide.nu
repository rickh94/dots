let-env config = ($env | default {} config).config
let-env config = ($env.config | default {} hooks)
let-env config = ($env.config | update hooks ($env.config.hooks | default {} env_change))
let-env config = ($env.config | update hooks.env_change ($env.config.hooks.env_change | default [] PWD))
let-env config = ($env.config | update hooks.env_change.PWD ($env.config.hooks.env_change.PWD | append {|_, dir|
  zoxide add -- $dir
}))

def-env __zoxide_z [...rest:string] {
  let arg0 = ($rest | append '~').0
  let path = if (($rest | length) <= 1) && ($arg0 == '-' || ($arg0 | path expand | path type) == dir) {
    $arg0
  } else {
    (zoxide query --exclude $env.PWD -- $rest | str trim -r -c "\n")
  }
  cd $path
}

def-env __zoxide_zi  [...rest:string] {
  cd $'(zoxide query -i -- $rest | str trim -r -c "\n")'
}

alias z = __zoxide_z
alias zi = __zoxide_zi
