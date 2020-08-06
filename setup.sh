#!/usr/bin/env bash
declare -r CURRENT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
declare -r now=$(date +%Y%m%d-%H%M%S)

# Print stderr in red
exec 2> >(while read line; do echo -e "\e[31m[stderr]\e[0m $line"; done)

# Immediately exit on failure
set -eou pipefail

IFS=$'\n\t'

# TODO: Use ZSH_CONFIG="$HOME/config/.zsh"
ZSH_CONFIG="$HOME/.zsh"
mkdir -pv "$(dirname "$ZSH_CONFIG")"

# Create $HOME/.zsh symlink
current_zsh=$(readlink -f "$ZSH_CONFIG")
if [[ "$current_zsh" != "$CURRENT_DIR" ]]; then
	echo "Creating "$ZSH_CONFIG" symlink..."
	if [[ -e "$HOME/.zsh" ]]; then
		mv "$ZSH_CONFIG" $HOME/.zsh-old.$now
	fi
	echo ln -sf "$CURRENT_DIR" "$ZSH_CONFIG"
	ln -sf "$CURRENT_DIR" "$ZSH_CONFIG"
fi

# Create zsh symlinks
for file in zlogin zprofile zshenv zshrc bash_profile; do
	link=$HOME/.$file
	oldpath=$(readlink $link 2>/dev/null || echo .none)
	newpath=".zsh/$file"
	[[ $oldpath == $newpath ]] && continue
	[[ -e $link ]] && mv $link $link-old.$now
	echo ln -sf $newpath $link
	ln -sf $newpath $link
done

