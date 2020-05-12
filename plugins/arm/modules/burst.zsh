
# ==============================================================================
# FUNCTIONS
# ==============================================================================
function burstload() {
	local git_top new_top
	local default_top=/projects/pd/pj00311_burst/users/todyam01/tools-dev

	# Get git top
	git_top="$(git rev-parse --show-toplevel 2>/dev/null)"
	if [[ -f $git_top/bin/burst ]]; then
		new_top="$git_top"
	else
		new_top="$default_top"
	fi

	# Unload existing burst
	if (whence -p burst &>/dev/null); then
		local burstbin
		burstbin="$(whence -c -p burst 2>/dev/null)"
		top="$(dirname "$(dirname "$burstbin")")"
		if [[ "$top" != "$git_top" ]]; then
			module unload "$top/modulefile"
		fi
	fi

	# Load modulefile
	module load "$new_top/modulefile"
	#echo "BURST_ROOT=$BURST_ROOT"
	whence -c -p burst
}


# ==============================================================================
# COMPDEF
# ==============================================================================
compdef -d burst

