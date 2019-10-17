
# ==============================================================================
# PREEXEC
# ==============================================================================
# Executed just after a command has been read and is about to be executed.

function preexec() {

	# Set $DISPLAY
	local old_display=$DISPLAY
	_set-display $(_find-display)
	[[ $DISPLAY != $old_display ]] && echo -e "\x1b[38;5;8m\$DISPLAY=$DISPLAY\e[0m"

	# Set powerline
	_set-powerline

	# Enable tmux monitor
	_tmux-monitor on

	# Start timer
	unset _elapsed_ms
	echo -e "\x1b[38;5;8m[$(date +%T)] Starting timer\e[0m"
	_start_ms=$(_get-ms)
}


# ==============================================================================
# PRECMD
# ==============================================================================
# Executed before each prompt. Note that precommand functions are not re-executed simply because the command line is redrawn.
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
	_tmux-monitor off

	#[[ -e ${TMUX%%,*} ]] && tmux refresh-client

	# TODO: Fix MAGIC_ENTER_BUFFER
	#_autonotify
}

