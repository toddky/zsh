
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

# TODO: Test brew
#if [[ $OSTYPE == darwin* && $CPUTYPE == arm64 ]]; then
#	alias brew=/usr/local/homebrew/bin/brew
#fi
# or:
#path+=(/usr/local/homebrew/bin(/))


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
export ZSH_COMPDUMP="$ZSH_COMPDIR/$(hostname -f)"
autoload -U compinit
_comp_options+=(globdots)
compinit -i -C -d "$ZSH_COMPDUMP"

autoload colors && colors

# Use plugins
plugins=(auto my-zsh)
if [[ $(hostname -f) =~ arm.com$ ]]; then
	plugins+=(arm lsf eda)
fi
plugins+=(cd vim vi-mode setup svn)
plugins+=(fzf)
(which lpass &>/dev/null) && plugins+=(lpass)

# TODO: Investigate more plugins
# https://github.com/zsh-vi-more/vi-motions

# TODO: Checkout zsh4humans
# https://github.com/romkatv/zsh4humans

# Uncomment options for debug
#setopt XTRACE
#setopt VERBOSE
#setopt SOURCE_TRACE

for plugin in $plugins; do
	plugin_dir="$ZSH_CUSTOM/plugins/$plugin"
	if [[ ! -f "$plugin_dir/$plugin.plugin.zsh" ]]; then
		echo "Plugin '$plugin' not found"
		continue
	fi
	if ! (($fpath[(Ie)$plugin_dir])); then
		fpath+=("$plugin_dir")
	fi
	if [[ -d "$plugin_dir/bin" ]]; then
		path=("$plugin_dir/bin" "${path[@]}")
	fi
	source "$plugin_dir/$plugin.plugin.zsh"
done
source $ZSH_CUSTOM/themes/my-theme.zsh-theme
source $HOME/.zsh/zplugin

# Load compdef functions
autoload -U compaudit compinit

# Very cool plugin, just too slow
#source "$ZSH_CUSTOM/downloads/zsh-autocomplete.plugin.zsh"


# ==============================================================================
# INSTANT ZSH PROMPT
# ==============================================================================
# Must be called at the end of file
if ((instant)); then
	instant-zsh-post
fi

