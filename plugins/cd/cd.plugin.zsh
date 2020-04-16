
# --- Directory Stat ---
alias d='dirs -v'
function c() { cd -$1; }

# --- Aliases ---
alias cd='cd -P'
alias cdpwd='cd $PWD 2>/dev/null || cd $(pwd) 2>/dev/null && pwd'
alias cdtemp='cd $(mktemp -d)'
alias cdl='cd $(command ls -t | head -n 1)'
alias cdgit='cd $(git rev-parse --show-toplevel)'


# ==============================================================================
# FUNCTIONS
# ==============================================================================
function cdd() {
	cd $(dirname $(readlink -f $1))
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

