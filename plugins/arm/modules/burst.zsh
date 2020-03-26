
# ==============================================================================
# FUNCTIONS
# ==============================================================================
function burstload() {
	local git_top
	local default_top=/projects/pd/pj00311_burst/users/todyam01/tools-dev

	# Unload existing burst
	if (which burst &>/dev/null); then
		top=$(dirname $(dirname $(\which burst)))
		echo module unload $top/modulefile
		module unload $top/modulefile
	fi

	# Load burst
	git_top=$(git rev-parse --show-toplevel 2>/dev/null)
	if [[ -f $git_top/bin/burst ]]; then
		top=$git_top
	else
		top=$default_top
	fi

	module load $top/modulefile
	#echo "BURST_ROOT=$BURST_ROOT"
	which burst
}


# ==============================================================================
# COMPDEF
# ==============================================================================
compdef -d burst

