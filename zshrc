
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
if ((instant)) && [[ -f "$ZSH_CUSTOM/downloads/instant-zsh.zsh" ]]; then
	source "$ZSH_CUSTOM/downloads/instant-zsh.zsh"
	local instant_prompt=''
	instant_prompt+='%{%K{red}%F{white}%}LOADING...'
	instant_prompt+='%{%K{blue}%F{red}%}'
	instant_prompt+='%{%K{blue}%F{white}%}%1~'
	instant_prompt+='%{%K{default}%F{blue}%}'
	instant_prompt+='%{%f%}% '
	instant-zsh-pre "$instant_prompt"
fi


# ==============================================================================
# ZSHRC
# ==============================================================================
export ZSH=$HOME/.oh-my-zsh
export SHELL=$(builtin which zsh)

DISABLE_AUTO_TITLE=true
COMPLETION_WAITING_DOTS="true"

# Setup .zcompdump directory
[[ -z $ZSH_COMPDIR ]] && ZSH_COMPDIR=~/.config/zsh/zcompdir
mkdir -p $ZSH_COMPDIR
ZSH_COMPDUMP=$ZSH_COMPDIR/$(hostname --long)

plugins=(auto)
if [[ $(hostname --long) =~ arm.com$ ]]; then
	plugins+=(arm lsf eda)
fi
plugins+=(bin my-zsh cd vim xclip tmux vi-mode regex math setup git svn emacs)
plugins+=(fzf)
#plugins+=(history-substring-search)

# Uncomment options for debug
#setopt XTRACE
#setopt VERBOSE
#setopt SOURCE_TRACE

if ((profile)); then
	function source() {
		local start_ms=$(date +%s%3N)
		builtin source $1
		echo "$(($(date +%s%3N)-$start_ms)) $1"
	}
fi

autoload -Uz compinit
compinit -i

#export ZSH_DISABLE_COMPFIX=true
${ZSH_DISABLE_COMPFIX:=true}
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
((instant)) && instant-zsh-post

cowsay "ZSH_VERSION $ZSH_VERSION"

