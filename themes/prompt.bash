#!/usr/bin/env bash

# ==============================================================================
# PROMPT
# ==============================================================================
export PROMPT_BG=$1
#PROMPT_SEPARATOR=$'\ue0b0'
#RPROMPT_SEPARATOR=$'\ue0b2'
PROMPT_SEPARATOR=
function prompt-fg() {
	local fg="%{%F{$1}%}"
	shift && echo -n "${fg/\%F\{reset\}/%f}$@"
}
function prompt-bg() {
	local bg="%{%K{$1}%}"
	echo -n ${bg/\%K\{reset\}/%k}
	if [[ $PROMPT_BG != 'NONE' && $PROMPT_BG != $1 ]]; then
		echo -n "%F{$PROMPT_BG}%}$PROMPT_SEPARATOR"
	fi
	export PROMPT_BG=$1
}
function prompt-bg-fg() {
	prompt-bg $1
	shift && prompt-fg $@
}


# ==============================================================================
# USERNAME/HOST
# ==============================================================================
foreground=white
host='@%m'
username='%n'
username='todd'
[[ -n $LSB_BATCH_JID ]] && { foreground=yellow; host="@$LSB_BATCH_JID"; }
[[ -e ${TMUX%%,*} ]] && { foreground=green; host=""; }
prompt-fg $foreground "$username$host"


# ==============================================================================
# GIT
# ==============================================================================
function prompt-git() {

	# Get URL and branch
	url="$(git config --get remote.origin.url 2>/dev/null)"
	branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

	large_repos=(
		ssh://ds-gerrit.euhpc.arm.com:29418/svos/apps
		ssh://ds-gerrit.euhpc.arm.com:29418/svos/linux
		ssh://hw-gerrit.euhpc.arm.com:29418/systems/amis
		ssh://hw-gerrit.nahpc.arm.com:29418/cores/ares
		ssh://hw-gerrit.nahpc.arm.com:29418/systems/porter
		ssh://nasce-gerrit-1.sce01.na02.arm.com:29418/mirrors/na-gerrit-1.nahpc.arm.com/cores/ares
	)

	# Print basic branch information for large repos
	if [[ " ${large_repos[@]} " =~ " $url " ]]; then
		prompt-fg white " $branch"
		return 0
	fi

	# Print branch
	{
		foreground=green
		git rev-parse @{u} &>/dev/null || foreground=cyan
		git diff-index --quiet HEAD 2>/dev/null || foreground=red
		prompt-fg "$foreground" " $branch"
	} &

	# Get detailed status
	stat=$(git status -sb -uno 2>/dev/null | head -1)
	ahead=$(echo $stat | sed -n 's/.*ahead \([0-9]\+\).*/ +\1/p')
	behind=$(echo $stat | sed -n 's/.*behind \([0-9]\+\).*/ -\1/p')

	wait
	prompt-fg yellow "$ahead"
	prompt-fg red "$behind"
}

# Exit unless running in git
git rev-parse --is-inside-work-tree &>/dev/null && prompt-git


# ==============================================================================
# DIRECTORY
# ==============================================================================

# Get directory background color
# Blue:    Username in path
# Cyan:    Username not in path
# Red:     Bad permissions
# Magenta: vicmd mode
function dir-background() {
	if [[ $ZSH_KEYMAP == vicmd ]]; then
		echo -n magenta
		return 0
	elif ! (stat -c %n . &>/dev/null); then
		echo -n red
		return 0
	elif [[ ! $PWD =~ $(whoami) ]]; then
		echo -n cyan
		return 0
	else
		echo -n blue
		return 0
	fi
}
#prompt-bg $(dir-background) &
prompt-bg $(dir-background)

# Calculate permissions
function dir-permission() {
	local access me my_groups default=white
	local user_fg=$default group_fg=$default world_fg=$default
	access=$(stat -c %a . 2>/dev/null) || return

	# User permission
	me="$(whoami 2>/dev/null || echo NOBODY)"
	[[ "$me" == "$(stat -c %U . 2>/dev/null)" ]] || user_fg=red
	prompt-fg $user_fg $(echo $access | rev | cut -b 3)

	# Group permission
	my_groups="$(groups 2>/dev/null || echo NONE)"
	[[ $(groups) =~ $(stat -c %G . 2>&1) ]] || group_fg=red
	prompt-fg $group_fg $(echo $access | rev | cut -b 2)

	# World permission
	prompt-fg $world_fg $(echo $access | rev | cut -b 1)
}
permission=$(dir-permission)

#wait
prompt-fg white $permission "%1~"
#PROMPT_BG=$(dir-background)
prompt-bg-fg reset reset
[[ -n $POWERLINE ]] || echo -n "$no_color"

