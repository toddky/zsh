
local here=${0:h}
source $here/lib.zsh-theme

# Get prompt version
_prompt_version=$(git -C $here log -1 --format=%H 2>/dev/null || echo none)

# Disable right prompt
alias nor="function _rprompt-git(){}; function _prompt-git(){};"

# ==============================================================================
# $PROMPT
# ==============================================================================

# --- Prompt Status ---
# Status: Error?, Root?, Background Jobs?
function _prompt-status() {
	local symbols
	if [[ -n $POWERLINE ]]; then
		#(( $RETVAL == 0 )) && symbols+="${green}✔" || symbols+="${red}✘"
		[[ $UID -eq 0 ]] && symbols+="${yellow}⚡"
		[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="${cyan}⚙"
	else
		#(( $RETVAL == 0 )) && symbols+="${green}0" || symbols+="${red}X"
		[[ $UID -eq 0 ]] && symbols+="${yellow}Z"
		[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="${cyan}B"
	fi
	_prompt-bg-fg black default "$symbols"
}

# --- Git Status ---
function _prompt-git() {
	$here/git.bash
}


# --- SVN Status ---
function _prompt-svn() {
	_svn-check || return
	_prompt-bg-fg black white ' .svn'
}


# --- Build Prompt ---
build_prompt() {
	_prompt-start
	PROMPT_BG='NONE'
	_prompt-bg black
	_prompt-status
	_projects-status
	_hostinfo
	[[ $_prompt_version == $(_prompt-git-version) ]] || echo -n $_ZSH_DEGREE
	_prompt-git
	_prompt-svn
	_dir-permission
	_prompt-end
}


# ==============================================================================
# $RPROMPT
# ==============================================================================

# --- Right Prompt Elapsed Time ---
function _rprompt-time() {
	_rprompt-bg-fg blue white $(_elapsed-time)
}

# --- Build Right Prompt ---
build_rprompt() {
	#_rprompt-start
	#_rprompt-git
	#_rprompt-time
}

