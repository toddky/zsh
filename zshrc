
# ==============================================================================
# SETTINGS
# ==============================================================================
export ZSH_CUSTOM=$HOME/.zsh
local profile=0
#profile=1
local instant=1
#instant=0


# ==============================================================================
# INSTANT ZSH PROMPT
# ==============================================================================
if ((instant)); then
	if [[ -f "$ZSH_CUSTOM/downloads/instant-zsh.zsh" ]]; then
		source "$ZSH_CUSTOM/downloads/instant-zsh.zsh"
		local instant_prompt=''
		instant_prompt+='%{%K{red}%F{white}%}LOADING...'
		instant_prompt+='%{%K{blue}%F{red}%}'
		instant_prompt+='%{%K{blue}%F{white}%}%1~'
		instant_prompt+='%{%K{default}%F{blue}%}'
		instant_prompt+='%{%f%}% '
		instant-zsh-pre "$instant_prompt"

	# Unset instant if source file not found
	else
		instant=0
	fi
fi

# ==============================================================================
# $PATH
# ==============================================================================
typeset -U path
[[ -d '/opt/homebrew/bin' ]] && path+=('/opt/homebrew/bin')
[[ -d "$HOME/.local/bin" ]] && path+=("$HOME/.local/bin")
path=("$ZSH_CUSTOM/bin" "${path[@]}")
path=("$HOME/bin" "${path[@]}")


# ==============================================================================
# ZSHRC
# ==============================================================================
export ZSH=$HOME/.oh-my-zsh
export SHELL=$(builtin which zsh)

if ((profile)); then
	function source() {
		local start_ms=$(date +%s%3N)
		builtin source $1
		echo "$(($(date +%s%3N)-$start_ms)) $1"
	}
fi

# Setup compinit directory
[[ -z $ZSH_COMPDIR ]] && export ZSH_COMPDIR=~/.config/zsh/zcompdir
mkdir -p "$ZSH_COMPDIR" &> /dev/null
export ZSH_COMPDUMP="$ZSH_COMPDIR/$(hostname --long)"
autoload -U compinit
_comp_options+=(globdots)
compinit -i -C -d "$ZSH_COMPDUMP"

autoload colors && colors

# Use plugins
plugins=(auto my-zsh)
if [[ $(hostname --long) =~ arm.com$ ]]; then
	plugins+=(arm lsf eda)
fi
plugins+=(bin cd vim tmux vi-mode regex math setup git svn emacs)
plugins+=(fzf)
(which lpass &>/dev/null) && plugins+=(lpass)
(which xclip &>/dev/null) && plugins+=(xclip)

# TODO: Investigate more plugins
# https://github.com/zsh-vi-more/vi-motions

# TODO: Checkout zsh4humans
# https://github.com/romkatv/zsh4humans

# Uncomment options for debug
#setopt XTRACE
#setopt VERBOSE
#setopt SOURCE_TRACE

for plugin in $plugins; do
	source "$ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh"
done
source $ZSH_CUSTOM/themes/my-theme.zsh-theme
source $HOME/.zsh/zplugin

# Very cool plugin, just too slow
#source "$ZSH_CUSTOM/downloads/zsh-autocomplete.plugin.zsh"


# ==============================================================================
# INSTANT ZSH PROMPT
# ==============================================================================
# Must be called at the end of file
if ((instant)); then
	instant-zsh-post
fi

