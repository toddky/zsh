#!/usr/bin/env bash

# Exit unless running in git
git rev-parse --is-inside-work-tree &>/dev/null || exit

# Check blacklist
url=$(git config --get remote.origin.url 2>/dev/null) || exit
blacklist=()
#blacklist+=(ssh://hw-gerrit.nahpc.arm.com:29418/systems/porter)
blacklist+=(ssh://ds-gerrit.euhpc.arm.com:29418/svos/linux)
blacklist+=(ssh://ds-gerrit.euhpc.arm.com:29418/svos/apps)
blacklist+=(ssh://hw-gerrit.nahpc.arm.com:29418/cores/ares)
blacklist+=(ssh://hw-gerrit.euhpc.arm.com:29418/systems/amis)

# Print prompt
function prompt-fg() {
	local fg="%{%F{$1}%}"
	shift && echo -n "${fg/\%F\{reset\}/%f}$@"
}

# Print branch for blacklist
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [[ " ${blacklist[@]} " =~ " $url " ]]; then
	prompt-fg white " $branch"
	exit
fi

# TODO: Optimize this section
foreground=green
git rev-parse @{u} &>/dev/null || foreground=cyan
git diff-index --quiet HEAD 2>/dev/null || foreground=red
stat=$(git status -sb -uno 2>/dev/null | head -1)
ahead=$(echo $stat | sed -n 's/.*ahead \([0-9]\+\).*/ +\1/p')
behind=$(echo $stat | sed -n 's/.*behind \([0-9]\+\).*/ -\1/p')

# Print prompt stuff
prompt-fg "$foreground" " $branch"
prompt-fg yellow "$ahead"
prompt-fg red "$behind"

