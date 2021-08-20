#!/usr/bin/env bash
function _realpath() {
	echo "$(cd "$(dirname "$1")"; pwd)"
}
declare -r CURRENT_DIR="$(_realpath "${BASH_SOURCE[0]}")"
declare -r now=$(date +%Y%m%d-%H%M%S)

# Print stderr in red
exec 2> >(while read line; do printf "\e[31m[stderr]\e[0m $line\n"; done)

# Immediately exit on failure
set -eou pipefail

# Install zsh
which zsh &> /dev/null || sudo apt install -y zsh

IFS=$'\n\t'

# TODO: Use ZSH_CONFIG="$HOME/config/.zsh"
ZSH_CONFIG="$HOME/.zsh"
mkdir -pv "$(dirname "$ZSH_CONFIG")"

# Create $HOME/.zsh symlink
current_zsh=$(_realpath "$ZSH_CONFIG")
if [[ "$current_zsh" != "$CURRENT_DIR" ]]; then
	echo "Creating "$ZSH_CONFIG" symlink..."
	if [[ -e "$HOME/.zsh" ]]; then
		mv "$ZSH_CONFIG" $HOME/.zsh-old.$now
	fi
	echo "\$> ln -s '$CURRENT_DIR' '$ZSH_CONFIG'"
	ln -s "$CURRENT_DIR" "$ZSH_CONFIG"
fi

# Create zsh symlinks
for file in zlogin zprofile zshenv zshrc bash_profile; do
	link="$HOME/.$file"
	oldpath=$(_realpath "$link" 2>/dev/null || echo .none)
	newpath=".zsh/$file"
	[[ "$oldpath" == "$newpath" ]] && continue
	[[ -e "$link" ]] && mv "$link" "$link-old.$now"
	echo "\$> ln -s '$newpath' '$link'"
	ln -s "$newpath" "$link"
done

# Update submodules
git -C "$CURRENT_DIR" submodule update --init --remote --recursive

