#!/usr/bin/env bash
# Find a $DISPLAY that works and print it to stdout
# Debug information gets printed to stderr

# Check $DISPLAY_force
if [[ -n "$DISPLAY_force" ]]; then
	if (xdpyinfo -display "$DISPLAY_force" &>/dev/null); then
		echo "[debug] Use \$DISPLAY_force='$DISPLAY_force'" 1>&2
		echo "$DISPLAY_force"
		exit
	else
		echo "[debug] ERROR: Display broken \$DISPLAY_force='$DISPLAY_force'" 1>&2
	fi
fi

# Check $DISPLAY_vnc
if [[ -n "$DISPLAY_vnc" ]]; then
	if (xdpyinfo -display $DISPLAY_vnc &>/dev/null); then
		echo "[debug] Use \$DISPLAY_vnc='$DISPLAY_vnc'" 1>&2
		echo "$DISPLAY_vnc"
		exit
	else
		echo "[debug] ERROR: Display broken \$DISPLAY_vnc='$DISPLAY_vnc'" 1>&2
	fi
fi

# Check $DISPLAY
if ( xdpyinfo -display "$DISPLAY" &>/dev/null ); then
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
	if ( xdpyinfo -display "$display" &>/dev/null ); then
		#echo -e "\e[32mPASS\e[0m $display" 1>&2
		echo "$display"
		exit
	#else
		#echo -e "\e[31mFAIL\e[0m $display" 1>&2
	fi
done < <(tac "$display_file")

