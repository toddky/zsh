
# ==============================================================================
# RUN LATEST ZSH
# ==============================================================================
# This is a stupid hack that will probably break and cause infinite recursion
if [[ -n $PROMPT && -d /arm/tools/ ]]; then

	rhe=$(lsb_release -rs | cut -f1 -d.)
	if [[ $rhe == 6 ]]; then
		PATH="/arm/tools/zsh/zsh/5.7.1/rhe6-x86_64/bin:$PATH"
	elif [[ $rhe == 7 ]]; then
		PATH="/arm/tools/zsh/zsh/5.7.1/rhe7-x86_64/bin:$PATH"
	fi
	MANPATH="/arm/tools/zsh/zsh/5.7.1/common/man:$MANPATH"

	if [[ $ZSH_VERSION != $(zsh --version | cut -d' ' -f 2) ]]; then
		exec zsh
	fi
fi


# ==============================================================================
# ENVIRONMENT
# ==============================================================================
export PAGER='less -r'
export TERM=xterm-256color
export XDG_CONFIG_HOME=$HOME/.config

# Display settings
if [[ -n "$DISPLAY" ]]; then
	grep "$DISPLAY" $XDG_CONFIG_HOME/DISPLAY &>/dev/null || echo "$DISPLAY" >> $XDG_CONFIG_HOME/DISPLAY
fi
export DISPLAY_orig="$DISPLAY"
[[ -n "$VNCDESKTOP" ]] && export DISPLAY_vnc="$DISPLAY"


# ==============================================================================
# SETTINGS
# ==============================================================================
# Disable XON/XOFF flow control
# Fixes Ctrl-s causing Vim to hang
stty -ixon 2>/dev/null

