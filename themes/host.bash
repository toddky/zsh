#!/usr/bin/env bash

foreground=white
host='@%m'
username='%n'
username='todd'
[[ -n $LSB_BATCH_JID ]] && { foreground=yellow; host="@$LSB_BATCH_JID"; }
[[ -e ${TMUX%%,*} ]] && { foreground=green; host=""; }

# Print prompt
function prompt-fg() {
	local fg="%{%F{$1}%}"
	shift && echo -n "${fg/\%F\{reset\}/%f}$@"
}
prompt-fg $foreground "$username$host"

# NOT USED: Print project status
exit
function _rojects-status() {

	# Check $BURST_ROOT
	if [[ -d "$BURST_ROOT" ]]; then
		_prompt-fg green $_ZSH_STAR_SOLID
		return
	fi

	# Check $PROJ_HOME
	[[ -d $PROJ_HOME ]] || return
	local fg=red simcmd
	[[ -d $WORK_DIR ]] && star=$_ZSH_STAR_SOLID
	simcmd=$(\which sim_tb 2>/dev/null)
	[[ $simcmd -ef $PROJ_HOME/tools/shared/bin/sim_tb ]] && fg=green
	_prompt-fg $fg $star
}

