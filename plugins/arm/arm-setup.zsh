
# Check if already loaded
((_ARM_SETUP_LOADED)) && return
export _ARM_SETUP_LOADED=1

# --- module commands ---
source $DEPOT_SETUP_ROOT/init/bash.d/modules-init

# --- module autocompletion ---
#autoload bashcompinit
#bashcompinit
#source $DEPOT_SETUP_ROOT/init/bash.d/modules-autocompletion

# --- module autocompletion ---
function shopt(){}
source $DEPOT_SETUP_ROOT/init/bash.d/shell-config
unfunction shopt

# --- ~/.zlogin  ---
[[ -f ~/.zlogin ]] && source ~/.zlogin

# --- mrun ---
alias -g mrun=/arm/tools/setup/bin/mrun

