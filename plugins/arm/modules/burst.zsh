
# ==============================================================================
# FUNCTIONS
# ==============================================================================
function burstload() {
	local top

	# Unload existing burst
	if (which burst &>/dev/null); then
		top=$(dirname $(dirname $(\which burst)))
		echo $top
		module unload $top/modulefile
	fi

	# Load burst
	top=$(git rev-parse --show-toplevel 2>/dev/null)
	if [[ ! -f $top/bin/burst ]]; then
		echo "Burst module not found"
		return 2
	fi
	module load $top/modulefile
}

