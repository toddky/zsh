
# ==============================================================================
# INSTANT ZSH PROMPT
# ==============================================================================
if [[ -f $HOME/.zsh/downloads/instant-zsh.zsh ]]; then
	source $HOME/.zsh/downloads/instant-zsh.zsh
	local instant_prompt=''
	instant_prompt+='%{%K{red}%F{white}%}LOADING...'
	instant_prompt+='%{%K{blue}%F{red}%}'
	instant_prompt+='%{%K{blue}%F{white}%}%1~'
	instant_prompt+='%{%K{default}%F{blue}%}'
	instant_prompt+='%{%f%}% '
	instant-zsh-pre "$instant_prompt"
fi


# ==============================================================================
# OH-My-ZSH
# ==============================================================================
# TODO: Investigate antibody: https://github.com/getantibody/antibody

export ZSH=$HOME/.oh-my-zsh
export SHELL=$(builtin which zsh)
export ZSH_CUSTOM=$HOME/.zsh

DISABLE_AUTO_TITLE=true
COMPLETION_WAITING_DOTS="true"

# Setup .zcompdump directory
[[ -z $ZSH_COMPDIR ]] && ZSH_COMPDIR=~/.zcompdir
mkdir -p $ZSH_COMPDIR
ZSH_COMPDUMP=$ZSH_COMPDIR/$(hostname --long)

# Setup theme
ZSH_THEME_DEFAULT="my-theme"
[[ -z $ZSH_THEME ]] && ZSH_THEME=$ZSH_THEME_DEFAULT

if [[ $(hostname --long) =~ arm.com$ ]]; then
	plugins=(arm lsf eda)
else
	function module(){}
fi
plugins+=(bin modules my-zsh cd vim xclip tmux vi-mode regex math setup git svn emacs)
[[ -f ~/.fzf.zsh ]] && plugins+=(fzf)
plugins+=(history-substring-search)

# Uncomment options for debug
#setopt XTRACE
#setopt VERBOSE
#setopt SOURCE_TRACE

# Uncomment to profile
#local profile=1
if ((profile==1)); then
	function source() {
		local start_ms=$(date +%s%3N)
		builtin source $1
		echo "$(($(date +%s%3N)-$start_ms)) $1"
	}
fi

#export ZSH_DISABLE_COMPFIX=true
${ZSH_DISABLE_COMPFIX:=true}
source $ZSH/oh-my-zsh.sh

source $HOME/.zsh/zplugin


# Instant zsh prompt
# Must be called at the end of file
instant-zsh-post

