
# --- Copy/Paste ---
function copy() { eval "$@" | _xclip; }
function _xclip() {
	xclip
	[[ -e ${TMUX%%,*} ]] && tmux set-buffer "$(xclip -o)"
	return 0
}
alias -g _paste='$(xclip -o)'
alias echop='echo Clipboard: _paste'

# --- Files/Directories ---
function clip() { copy readlink -f $1; echop; }
alias cdp='echo_eval cd _paste'
alias cpp.='echo_eval cp _paste .'

