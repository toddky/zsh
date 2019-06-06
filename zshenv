
# --- Set Environment Variables ---
export PAGER='less -r'
export TERM=xterm-256color

# --- Display Setup ---
if [[ -n $DISPLAY ]]; then
	grep ${DISPLAY} $HOME/.DISPLAY &>/dev/null || echo $DISPLAY >> $HOME/.DISPLAY
fi
export DISPLAY_orig="$DISPLAY"
[[ -n $VNCDESKTOP ]] && export DISPLAY_vnc=$DISPLAY

# --- Terminal Line Settings ---
# Disable XON/XOFF flow control
# Fixes Ctrl-s causing Vim to hang
stty -ixon 2>/dev/null

# --- Run Latest zsh ---
# This is a stupid hack that will probably break and cause infinite recursion
if [[ -d /arm/tools/ ]]; then
	PATH=/arm/tools/zsh/zsh/5.2/rhe6-x86_64/bin:$PATH
	if [[ $ZSH_VERSION != $(zsh --version | cut -d' ' -f 2) ]]; then
		exec zsh
	fi
fi

