
# Always define module function
function module() {
	local tcl rhe processor
	rhe=$(lsb_release -r | sed 's/Release:\s\+\([0-9]\).*/\1/')
	processor=$(uname -p)
	tcl="/arm/tools/tct/tcl/8.5.2/rhe${rhe}-${processor}/bin/tclsh"
	eval `$tcl /arm/tools/setup/lib/modulecmd.tcl bash $*`
}

# Check if already loaded
((_ARM_SETUP_LOADED)) && return
export _ARM_SETUP_LOADED=1
export LOADEDMODULES=
export LOADEDMODULES_modshare=
export DEPOT_SETUP_ROOT=/arm/tools/setup

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
umask 002

# --- ~/.zlogin  ---
[[ -f ~/.zlogin ]] && source ~/.zlogin

# --- mrun ---
alias -g mrun=/arm/tools/setup/bin/mrun

