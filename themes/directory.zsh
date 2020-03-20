
# --- Directory ---
# BG Blue: Username in path
# BG Cyan: Username not in path
# BG Red: Bad permissions
# BG Magenta: vicmd mode
function _dir-permission() {
	local p=${PWD/$HOME/\~} bg=blue
	[[ $PWD =~ $(whoami) ]] || bg=cyan
	permission=$(_permission-ugo)
	[[ -n $permission ]] || bg=red
	[[ $KEYMAP == vicmd ]] && bg=magenta
	p=$(basename ${p:gs/%/%%})
	_prompt-bg-fg $bg white $permission $p
}

# --- Permission ---
function _permission-ugo() {
	local access me my_groups default=white
	local user_fg=$default group_fg=$default world_fg=$default
	access=$(stat -c %a . 2>/dev/null) || return

	# User permission
	me="$(whoami 2>/dev/null || echo NOBODY)"
	[[ "$me" == "$(stat -c %U . 2>/dev/null)" ]] || user_fg=red
	_prompt-fg $user_fg "$access[-3]"

	# Group permission
	my_groups="$(groups 2>/dev/null || echo NONE)"
	[[ $(groups) =~ $(stat -c %G . 2>&1) ]] || group_fg=red
	_prompt-fg $group_fg "$access[-2]"

	# World permission
	_prompt-fg $world_fg "$access[-1]"
}

