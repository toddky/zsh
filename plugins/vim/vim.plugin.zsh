
local here=${0:h}
source $here/suffix.zsh
source $here/server.zsh

# ==============================================================================
# ENVIRONMENT
# ==============================================================================
export EDITOR=vim
export MANPAGER="vim -c MANPAGER -"


# ==============================================================================
# ALIASES
# ==============================================================================
alias vi=vim
alias vless="col -b | vim -c 'set ts=8 nomod nolist' -"
alias vman='vim -c MANPAGER -'
alias vmin='vim --noplugin'
alias vnone='vim -u NONE'
alias vdiff='vimdiff'
alias vall="vim -c 'tab sball'"
alias vwiki='vim +VimwikiIndex'


# ==============================================================================
# FUNCTIONS
# ==============================================================================

function vsource() { vim -S $@; }
function vs()      { vim -S $@; }

function vburst() {
	local uart=${1?} syntax
	syntax='syntax=burstlog'
	if [[ "$(file $uart)" =~ ' LF ' ]]; then
		(
			strings $uart
			echo "# vim: $syntax"
		) | vim -
	else
		vim -c "set $syntax" $uart
	fi
}

function vhelp() {
	vim +"help $@ | only"
}

# TODO: Clean up this function
function vimswp() {
	vim -r 2>&1 | awk '/^[0-9]/{file=$2}/process ID:/{print $0, file}'
}

# TODO: Make this function work
# Find tmux session with vim .swp file
function vtfind() {
	local -U pids
	vimswp | command grep -Po 'process ID: \K[0-9]+'
	#pids=(vimswp | command grep -Po 'process ID: \K[0-9]+')
	#for pid in $pids; do
		#echo "a $pid"
	#done
	#pid=$(lsof -t $1 2>/dev/null)
	#local pid=$(lsof -t $1)
	#echo "PID: $pid"
	#local pts=$(ps -o tty= -p $pid)
	#echo "PTS: $pts"
	#session=$(tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_tty}' | grep $pts)
	#echo $session
}

# Stolen from here:
# https://vi.stackexchange.com/questions/8835/how-to-output-result-of-vim-commands-to-shell
function vimscripts() {
	vim -c ':set t_ti= t_te= nomore' -c scriptnames -c q
}


# ==============================================================================
# COMPDEF
# ==============================================================================
function _source_vim() {
	_arguments "*:files:(($(ls *.vim)))"
}
compdef _source_vim vs vsource

