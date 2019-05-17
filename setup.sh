#!/usr/bin/env bash
declare -r script=$(readlink -f $BASH_SOURCE)
declare -r script_dir=$(dirname $script)
function _git() { git -C $script_dir $@; }
declare -r top=$(_git rev-parse --show-toplevel 2>/dev/null)
declare -r now=$(date +%Y%m%d-%H%M%S)

# Print stderr in red
exec 2> >(while read line; do echo -e "\e[31m[stderr]\e[0m $line"; done)

# Print custom pipe in blue
exec 5> >(while read line; do echo -e "\e[34m$line\e[0m"; done)

# Immediately exit on failure
set -eo pipefail
#set -euo pipefail

IFS=$'\n\t'

# Create ~/.zsh symlink
current_zsh=$(readlink -f ~/.zsh)
if [[ $current_zsh != $top ]]; then
	echo "Creating ~/.zsh symlink..." 1>&5
	[[ -e ~/.zsh ]] && mv ~/.zsh ~/.zsh-old.$now
	ln -sf $top ~/.zsh
fi

for f in zlogin zprofile zshenv zshrc; do
	[[ -e ~/.$f ]] && mv ~/.$f ~/.$f-old.$now
	ln -sf .zsh/$f ~/.$f
done

# Install zplugin
declare -r zplugin_install=https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh
sh -c "$(curl -fsSL )"

