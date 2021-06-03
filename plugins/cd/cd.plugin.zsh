
# ==============================================================================
# ALIASES
# ==============================================================================
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias cd='cd -P'
alias cdpwd='cd $PWD 2>/dev/null || cd $(pwd) 2>/dev/null && pwd'
alias cdtemp='cd $(mktemp -d)'
alias cdl='cd $(command ls -t | head -n 1)'
alias cdgit='cd $(git rev-parse --show-toplevel)'
alias cdp='cd $(,paste)'
alias d='dirs -v'


# ==============================================================================
# FUNCTIONS
# ==============================================================================
function c() { cd -$1; }
function cdd() {
	cd $(dirname $(readlink -f $1))
}
function cdw() {
	cd $(dirname $(whence -p $1))
}
function cdburst() {
	burst root || return $?
	cd "$BURST_ROOT"
}

# `cd` using `nnn`
# Taken from here:
# https://github.com/jarun/nnn/blob/master/misc/quitcd/quitcd.bash_zsh
function cdn() {
	if ! (which nnn &>/dev/null); then
		echo "nnn not found"
		return
	fi

	# Block nesting of nnn in subshells
	if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
		echo "nnn is already running"
		return
	fi

	# The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
	# To cd on quit only on ^G, remove the "export" as in:
	#     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
	# NOTE: NNN_TMPFILE is fixed, should not be modified
	export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

	# Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
	# stty start undef
	# stty stop undef
	# stty lwrap undef
	# stty lnext undef

	if (which ,nnn &>/dev/null); then
		,nnn "$@"
	else
		nnn "$@"
	fi

	if [ -f "$NNN_TMPFILE" ]; then
			. "$NNN_TMPFILE"
			rm -f "$NNN_TMPFILE" > /dev/null
	fi
}

# --- cup ---
# cd 'up'
function cup() {
	cd ${PWD%$1/*}/$1
	pwd
}

# --- chpwd ---
# Automatically generate $CDPATH and $GIT_TOP whenever the directory is changed
export GIT_TOP
function chpwd() {
	local up up2
	up=$(dirname $PWD)
	up2=$(dirname $up)
	export GIT_TOP=$(git rev-parse --show-toplevel 2>/dev/null)
	cdpath=('.' $GIT_TOP ${up%/} ${up2%/} $HOME/.links $HOME)
}
chpwd

