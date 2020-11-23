#!/usr/bin/env zsh

# ==============================================================================
# SETUP
# ==============================================================================
# Load hooks
autoload -Uz add-zsh-hook


# ==============================================================================
# FUNVTIONS
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


# ==============================================================================
# PREEXEC
# ==============================================================================
# Executed just after a command has been read and is about to be executed.
function _myzshtheme_preexec() {
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
if [[ ${preexec_functions[(ie)_myzshtheme_preexec]} -le ${#_myzshtheme_preexec} ]]; then
	add-zsh-hook preexec _myzshtheme_preexec
fi


# ==============================================================================
# PRECMD
# ==============================================================================
# Executed before each prompt.
# Note that precommand functions are not re-executed simply because the command line is redrawn.
# e.g. when a notification about an exiting job is displayed.
function _myzshtheme_precmd() {

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
if [[ ${precmd_functions[(ie)_myzshtheme_precmd]} -le ${#_myzshtheme_precmd} ]]; then
	add-zsh-hook precmd _myzshtheme_precmd
fi

# List hooks
#add-zsh-hook -L

