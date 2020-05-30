#!/usr/bin/env bash
# Find a $DISPLAY that works and print it to stdout
# Debug information gets printed to stderr

# Function to check display
function check_display() {
	xdpyinfo -display "$1" &>/dev/null
}

# Check $DISPLAY_force
if [[ -n "$DISPLAY_force" ]]; then
	if (check_display "$DISPLAY_force"); then
		echo "[debug] Use \$DISPLAY_force='$DISPLAY_force'" 1>&2
	else
		echo "[debug] ERROR: Display broken \$DISPLAY_force='$DISPLAY_force'" 1>&2
	fi
	# Always use $DISPLAY_force even if it's broken
	echo "$DISPLAY_force"
	exit
fi

# Check $DISPLAY_vnc
if [[ -n "$DISPLAY_vnc" ]]; then
	if (check_display "$DISPLAY_vnc"); then
		echo "[debug] Use \$DISPLAY_vnc='$DISPLAY_vnc'" 1>&2
		echo "$DISPLAY_vnc"
		exit
	else
		echo "[debug] ERROR: Display broken \$DISPLAY_vnc='$DISPLAY_vnc'" 1>&2
	fi
fi

# Check $DISPLAY
if (check_display "$DISPLAY"); then
	echo -e "[debug] Using \$DISPLAY='$DISPLAY'" 1>&2
	echo "$DISPLAY"
	exit
fi

# Check DISPLAY file
if [[ -f "$HOME/.config/DISPLAY" ]]; then
	display_file="$HOME/.config/DISPLAY"
elif [[ -f "$HOME/.DISPLAY" ]]; then
	display_file="$HOME/.DISPLAY"
else
	echo "[debug] No DISPLAY file found" 1>&2
	exit
fi
echo "[debug] Using display file '$display_file'" 1>&2

# Find display from DISPLAY file
while read -r display; do
	[[ -z "$display" ]] && continue
	if (check_display "$display"); then
		#echo -e "\e[32mPASS\e[0m $display" 1>&2
		echo "$display"
		exit
	#else
		#echo -e "\e[31mFAIL\e[0m $display" 1>&2
	fi
done < <(tac "$display_file")

