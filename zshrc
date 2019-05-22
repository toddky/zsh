
export SHELL=$(builtin which zsh)

DISABLE_AUTO_TITLE=true
COMPLETION_WAITING_DOTS="true"

# --- Setup .zcompdump Directory ---
[[ -z $ZSH_COMPDIR ]] && ZSH_COMPDIR=~/.zcompdir
mkdir -p $ZSH_COMPDIR
ZSH_COMPDUMP=$ZSH_COMPDIR/$(hostname --long)

source $HOME/.zsh/zplugin.zsh
source $ZSH/themes/my-theme.zsh-theme

