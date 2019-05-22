
# ==============================================================================
# ZPLUGIN
# ==============================================================================

# --- Install ---
source $HOME/.zplugin/bin/zplugin.zsh
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin


# ==============================================================================
# MY PLUGINS
# ==============================================================================

export ZSH=$HOME/.zsh


# TODO: Figure out how to load my theme
#source $ZSH/themes/my-theme.zsh-theme

if [[ $(hostname --long) =~ arm.com$ ]]; then
	plugins=(arm lsf eda)
else
	function module(){}
fi
plugins+=(bin modules my-zsh cd vim xclip tmux vi-mode regex math setup git svn emacs)

for plugin in $plugins; do
	zplugin ice wait'!0'
	zplugin load $ZSH/plugins/$plugin
done

# ==============================================================================
# https://pastebin.com/vEzdwrVv
# ==============================================================================

zplugin ice wait'!0'
zplugin load zsh-users/zsh-completions

zplugin ice wait'!0'
zplugin load zsh-users/zsh-syntax-highlighting

#zplugin ice svn wait'!1'
#zplugin snippet PZT::modules/command-not-found

