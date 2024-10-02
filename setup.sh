#!/bin/bash

setup() {
	if [ -d "$HOME/.dotfiles" ]; then
		rm -rf "$HOME/.dotfiles"
	fi

	git clone --bare https://github.com/jblsp/dotfiles "$HOME/.dotfiles"
	git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout -f

	submodule_paths=$(grep 'path = ' "$HOME/.gitmodules" | sed 's/.*= //')
	for submodule_path in $submodule_paths; do
		full_path="$HOME/$submodule_path"
		if [ -d "$full_path" ]; then
			rm -rf "$full_path"
		fi
	done
	git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" submodule update --init --recursive
	git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" config --local status.showUntrackedFiles no
}

clean() {
	git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" update-index --assume-unchanged "$HOME/setup.sh"
	rm -f "$HOME/setup.sh"
}

if [[ "$1" == "--clean-only" ]]; then
	clean
else
	setup
	clean
fi
