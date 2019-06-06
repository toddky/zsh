#!/usr/bin/env bash
declare -r script=$(readlink -f $BASH_SOURCE)
declare -r script_dir=$(dirname $script)
function _git() { git -C $script_dir $@; }
declare -r top=$(_git rev-parse --show-toplevel 2>/dev/null)
declare -r now=$(date +%Y%m%d-%H%M%S)

# Print stderr in red
exec 2> >(while read line; do echo -e "\e[31m[stderr]\e[0m $line"; done)

# Immediately exit on failure
set -eo pipefail

IFS=$'\n\t'

# Create $HOME/.zsh symlink
current_zsh=$(readlink -f $HOME/.zsh)
if [[ $current_zsh != $top ]]; then
	echo "Creating $HOME/.zsh symlink..." 1>&5
	[[ -e $HOME/.zsh ]] && mv $HOME/.zsh $HOME/.zsh-old.$now
	ln -sf $top $HOME/.zsh
fi

# Create zsh symlinks
for file in zlogin zprofile zshenv zshrc; do
	link=$HOME/.$file
	oldpath=$(readlink $link 2>/dev/null || echo .none)
	newpath=".zsh/$file"
	[[ $oldpath == $newpath ]] && continue
	[[ -e $link ]] && mv $link $link-old.$now
	echo ln -sf $newpath $link
	ln -sf $newpath $link
done

