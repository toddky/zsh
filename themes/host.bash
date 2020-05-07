#!/usr/bin/env bash

foreground=white
host='@%m'
[[ -n $LSB_BATCH_JID ]] && { foreground=yellow; host="@$LSB_BATCH_JID"; }
[[ -e ${TMUX%%,*} ]] && { foreground=green; host=""; }

# Print prompt
function prompt-fg() {
	local fg="%{%F{$1}%}"
	shift && echo -n "${fg/\%F\{reset\}/%f}$@"
}
prompt-fg $foreground "%n$host"

