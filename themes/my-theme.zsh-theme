
local here=${0:h}
source $here/directory.zsh
source $here/display.zsh
source $here/host.zsh
source $here/pre.zsh
source $here/projects.zsh
source $here/prompt.zsh
source $here/symbols.zsh
source $here/time.zsh
source $here/tmux.zsh

# --- Prompt Performance ---
function pperf() {
	_perf preexec
	_perf precmd
	_perf build_prompt
	_perf build_rprompt
}

function _perf() {
	local _start_ms=$(date +%s%3N)
	$@ > /dev/null
	echo "$1: $(($(date +%s%3N)-$_start_ms))"
}

# --- Set Title ---
function _set-title() {
	print -Pn "\e]0;$@\a"
}

# --- Set Prompt Version ---
function _prompt-git-version() {
	git -C $here log -1 --format=%H 2>/dev/null || echo none
}
_prompt_git_version=$(_prompt-git-version || echo fail)

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

# --- Build Prompt ---
build_prompt() {
	_prompt-start
	PROMPT_BG='NONE'
	_prompt-bg black
	_prompt-status
	_projects-status
	$here/host.bash
	[[ $_prompt_version == $(_prompt-git-version) ]] || echo -n $_ZSH_DEGREE
	$here/git.bash
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

