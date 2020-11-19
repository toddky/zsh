
export _MYZSHTHEME=${0:h}
source $_MYZSHTHEME/prompt.zsh
source $_MYZSHTHEME/hooks.zsh


# ==============================================================================
# SETTINGS
# ==============================================================================
setopt prompt_subst
autoload colors && colors

# Set $PROMPT and $RPROMPT
PROMPT='$(build_prompt)'
#RPROMPT='$(build_rprompt)'


# ==============================================================================
# $PROMPT
# ==============================================================================
export _MYZSHTHEME_VERSION="$(git -C $_MYZSHTHEME log -1 --format=%H 2>/dev/null || echo none)"
function build_prompt() {
	export _MYZSHTHEME_RETVAL=$?
	export _MYZSHTHEME_BG="$(jobs -l | wc -l)"
	$_MYZSHTHEME/prompt.bash 2>/dev/null
}

