
local here=${0:h}
export PATH=$here/bin:$PATH
export FZF_COMPLETION_DIR=$here/completion

# ==============================================================================
# SETUP
# ==============================================================================
source ~/.fzf.zsh
local fzfpath=$(git -C $(dirname $(which fzf)) rev-parse --show-toplevel)
source $fzfpath/shell/key-bindings.zsh
export MANPATH=$fzfpath/man:$MANPATH


# ==============================================================================
# KEY BINDINGS
# ==============================================================================

# History search
bindkey -M viins "^J" history-substring-search-down
bindkey -M viins "^K" history-substring-search-up

# History search
bindkey -M vicmd '^R' my-fzf-history
bindkey -M viins '^R' my-fzf-history

# History search with default fzf widget
#bindkey -M vicmd '^R' fzf-history-widget
#bindkey -M viins '^R' fzf-history-widget

# Shift-Tab to search files/directories
bindkey -M viins '^[[Z' fzf-magic-complete
bindkey -M viins '^[[Z' fzf-magic-complete

bindkey -M vicmd '^F' my-fzf-search
bindkey -M viins '^F' my-fzf-search


# ==============================================================================
# FUNCTIONS
# ==============================================================================

# List Git directories
function fzf-gitdirs() {
	[[ -d $GIT_TOP ]] || return 0
	# This is too slow for large directories
	#fzf-gitfiles | xargs -n 1 dirname | uniq
	git -C $GIT_TOP ls-files | sed -e 's/^/$GIT_TOP\//' -e 's/\/[^/]*$//' | awk '!count[$0]++'
}


# Recrusively list directories, shallow first
function fzf-dirs() {
	local dir file here=${1-.}
	local -U dirs
	dirs=($here)

	# For each directory
	while (( ${#dirs} != 0 )); do
		dir=$dirs[1]
		dirs[1]=()
		echo ${dir#./}

		# For each file
		for file in $(\ls $dir); do
			entry=$dir/$file
			[[ -d $entry ]] && dirs+=($entry)
		done
	done
}


# List hosts
function fzf-hosts() {
	command grep -oE '^[[a-z0-9.,:-]+' ~/.ssh/known_hosts | tr ',' '\n' | tr -d '[' | sort -u
}


# --- Widget ---

# Create fzf-magic-complete widget
zle -N fzf-magic-complete
function fzf-magic-complete() {
	local cmd ret query=${LBUFFER##* } accept
	setopt localoptions pipefail 2> /dev/null

	# Check if command matches completion directory
	cmd=$(echo $LBUFFER | awk '{print $1}')
	if [[ -x $FZF_COMPLETION_DIR/$cmd ]]; then
		result=$($FZF_COMPLETION_DIR/$cmd $LBUFFER)
		ret=$?
		[[ $ret == 0 ]] && LBUFFER=$result

	# SSH completion
	elif [[ $LBUFFER =~ '^\s*ssh\b' ]]; then
		LBUFFER="${LBUFFER% *} $(fzf-hosts | my-fzf-exact-40)"
		ret=$?

	# File completion
	else
		LBUFFER=$($FZF_COMPLETION_DIR/files)
		ret=$?
	fi

	zle redisplay
	typeset -f zle-line-init >/dev/null && zle zle-line-init
	[[ -n $accept ]] && zle accept-line
	return $ret
}


# Create my-fzf-history widget
zle -N my-fzf-history
function my-fzf-history() {
	setopt localoptions pipefail 2> /dev/null

	# Search history
	local result
	#result=($(fc -rl 1 | fzf --height 40% --reverse --bind=space:accept --tiebreak=index --query="$BUFFER"))
	result=($(fc -rl 1 | fzf --height 40% --reverse --tiebreak=index --query="$BUFFER"))
	#fzf --bind "enter:execute(less {})"
	local ret=$?

	# Apply search result
	if [[ -n "$result" ]]; then
		zle vi-fetch-history -n $result[1]
	fi

	# TODO: Is this stuff needed?
	# Redraw display
	zle redisplay
	typeset -f zle-line-init >/dev/null && zle zle-line-init
	return $ret
}


# Create my-fzf-search widget
zle -N my-fzf-search
function my-fzf-search() {
	setopt localoptions pipefail 2> /dev/null

	# Search in all files
	local result
	result=($(ag --nogroup '\w' | fzf --height 40% --reverse))
	local ret=$?

	# Apply search result
	if [[ -n "$result" ]]; then
		BUFFER=$(_vimline $result)
		zle accept-line
	fi

	# TODO: Is this stuff needed?
	# Redraw display
	zle redisplay
	typeset -f zle-line-init >/dev/null && zle zle-line-init
	return $ret
}

# Return command that opens result in vim
# This will fail if the file has a semicolon or space in the name
function _vimline() {
	local result file line
	result="$@"
	file=${result%%:*}
	if [[ -f $file ]]; then
		result=${result#$file:}
		line=$(echo $result | sed -n 's/\([0-9]\+\):.*/\1/p')
		echo "vim ${line:++$line }$file"
	fi
}

# Run ag/fzf, open result in vim
function agf() {
	local args cmd
	args="${@:-\w}"
	cmd=$(_vimline $(ag --nogroup $args | fzf))
	[[ -z "$cmd" ]] && return 0
	print -s $cmd
	eval $cmd
}

# Create message to display while fzf is running
function _fzf-running-msg() {
	while :; do
		for c in \\ \| / -; do
			echo -n "\r$c fzf is running"
			sleep 0.2
		done;
	done
}

