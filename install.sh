#!/bin/bash

# Setup git dir on $HOME
if [ -d "$HOME/.cfggit" ]; then
	rm -rf "$HOME/.cfggit"
fi
git clone --bare https://github.com/jblsp/dotfiles "$HOME/.cfggit"
git --git-dir="$HOME/.cfggit" --work-tree="$HOME" checkout -f
git --git-dir="$HOME/.cfggit/" --work-tree="$HOME" submodule update --init --recursive

# Update git config
git --git-dir="$HOME/.cfggit/" --work-tree="$HOME" config --local status.showUntrackedFiles no
git --git-dir="$HOME/.cfggit/" --work-tree="$HOME" update-index --assume-unchanged "$HOME/README.md" "$HOME/install.sh"

# Cleanup
rm -f "$HOME/README.md" "$HOME/install.sh"
