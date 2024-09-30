#!/bin/bash


# Setup git dir on $HOME
if [ -d "$HOME/.cfggit" ]; then
	rm -rf "$HOME/.cfggit"
fi
git clone --separate-git-dir="$HOME/.cfggit" https://github.com/jblsp/dotfiles "$HOME/dotfiles.tmp"
cp -r "$HOME/dotfiles.tmp/." "$HOME/"
rm -rf "$HOME/dotfiles.tmp"

submodule_paths=$(grep 'path = ' "$HOME/.gitmodules" | sed 's/.*= //')
for submodule_path in $submodule_paths; do
	full_path="$HOME/$submodule_path"
	if [ -d "$full_path" ]; then
		rm -rf "$full_path"
	fi
done
git --git-dir="$HOME/.cfggit/" --work-tree="$HOME" submodule update --init --recursive

# Update git config
git --git-dir="$HOME/.cfggit/" --work-tree="$HOME" config --local status.showUntrackedFiles no
git --git-dir="$HOME/.cfggit/" --work-tree="$HOME" update-index --assume-unchanged "$HOME/README.md" "$HOME/install.sh"

# Cleanup
rm -f "$HOME/README.md" "$HOME/install.sh"
