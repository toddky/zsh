
export _MYZSHTHEME=${0:h}
source $_MYZSHTHEME/prompt.zsh

# ==============================================================================
# SETTINGS
# ==============================================================================
setopt prompt_subst
autoload colors && colors

# Set $PROMPT and $RPROMPT
PROMPT='$(build_prompt)'
#RPROMPT='$(build_rprompt)'

# Symbols
# - Find more on Wikibooks:
#   https://en.wikibooks.org/wiki/Unicode/List_of_useful_symbols
_ZSH_PROMPT=❱
_ZSH_LEFT_SEPARATOR=
_ZSH_RIGHT_SEPARATOR=
_ZSH_GIT_BRANCH=
_ZSH_GIT_PUSH=↑
_ZSH_GIT_PULL=↓
_ZSH_DOT=•
_ZSH_STAR_HOLLOW=☆
_ZSH_STAR_SOLID=★
_ZSH_DEGREE=°


# ==============================================================================
# HOOKS
# ==============================================================================

# Get current time (ms)
function _get-ms() { date +%s%3N; }
[[ -z $_start_ms ]] && _start_ms=$(_get-ms)

# Autonotify
ZSH_NOTIFY_CMD='^\s*(git|svn)'
ZSH_NOTIFY_TIME='300000'
function _autonotify() {
	[[ $_elapsed_ms -gt $ZSH_NOTIFY_TIME ]] || return
	[[ $MAGIC_ENTER_BUFFER =~ $ZSH_NOTIFY_CMD ]] || return
	zenity --info --text "DONE: $(_elapsed-time) seconds\n$MAGIC_ENTER_BUFFER"
	tmux switch-client -t $(tmux display-message -p '#{session_id}') \; \
		select-window -t $(tmux display-message -p '#{window_id}') \; \
		select-pane -t $(tmux display-message -p '#{pane_id}')
}

# Executed just after a command has been read and is about to be executed.
function preexec() {
	# Set $DISPLAY
	local old_display="$DISPLAY"
	DISPLAY="$($_MYZSHTHEME/find-display.bash 2>/dev/null)"
	if [[ "$DISPLAY" != "$old_display" ]]; then
		\echo -e "\x1b[38;5;8m\$DISPLAY='$DISPLAY'\e[0m"
	fi

	# Set powerline
	_set-powerline

	# Set title
	#title='title'
	#print -Pn "\e]0;$title\a"

	# Enable tmux monitor
	[[ -e ${TMUX%%,*} ]] && tmux set-window monitor-activity on

	# Start timer
	unset _elapsed_ms
	echo -e "\x1b[38;5;8m[$(date +%T)] Starting timer\e[0m"
	_start_ms=$(_get-ms)
}

# Executed before each prompt.
# Note that precommand functions are not re-executed simply because the command line is redrawn.
# e.g. when a notification about an exiting job is displayed.
function precmd() {

	# Record elapsed time
	local RETVAL=$? _current_ms=$(_get-ms)

	# Print non-zero exit code
	(( $RETVAL == 0 )) || echo "\e[31mExit code: $RETVAL\e[0m"

	# Print elapsed time
	if (( ! ${+_elapsed_ms} )); then
		_elapsed_ms=$(($_current_ms-$_start_ms))

		# Print seconds
		printf "\x1b[38;5;8m[$(date +%T)] Execution time: "
		printf "%0.3fs" $(($_elapsed_ms/1000.0))

		# Print hours
		if (( _elapsed_ms > 3600000 )); then
			printf " (%0.2f hours)" $(($_elapsed_ms/3600000.0))
		fi
		printf "\e[0m\n"
	fi

	# Disable tmux monitor
	[[ -e ${TMUX%%,*} ]] && tmux set-window monitor-activity off
	#[[ -e ${TMUX%%,*} ]] && tmux refresh-client

	# TODO: Fix MAGIC_ENTER_BUFFER
	#_autonotify
}


# ==============================================================================
# $PROMPT
# ==============================================================================
function _prompt-git-version() {
	git -C $_MYZSHTHEME log -1 --format=%H 2>/dev/null || echo none
}
export PROMPT_VERSION=$(_prompt-git-version)


# --- Build Prompt ---
function build_prompt() {
	RETVAL=$?

	PROMPT_BG='NONE'
	_prompt-bg black

	# Check root
	[[ $UID -eq 0 ]] && echo -n "%{%F{yellow}%}⚡"

	# Backgrounnd job count
	[[ $(jobs -l | wc -l) -gt 0 ]] && echo -n "%{%F{cyan}%}[$(jobs -l | wc -l)] "

	# Run scripts to generate prompts
	$_MYZSHTHEME/host.bash 2>/dev/null
	[[ $PROMPT_VERSION == $(_prompt-git-version) ]] || echo -n $_ZSH_DEGREE
	$_MYZSHTHEME/git.bash 2>/dev/null
}

