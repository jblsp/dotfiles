#!/bin/bash

git_cmd="git --git-dir=\"$HOME/.dotfiles/\" --work-tree=\"$HOME\""

setup() {
	if [ -d "$HOME/.dotfiles" ]; then
		rm -rf "$HOME/.dotfiles"
	fi

	git clone --bare https://github.com/jblsp/dotfiles "$HOME/.dotfiles"
	$git_cmd -f

	submodule_paths=$(grep 'path = ' "$HOME/.gitmodules" | sed 's/.*= //')
	for submodule_path in $submodule_paths; do
		full_path="$HOME/$submodule_path"
		if [ -d "$full_path" ]; then
			rm -rf "$full_path"
		fi
	done
	$git_cmd submodule update --init --recursive
	$git_cmd config --local status.showUntrackedFiles no
}

clean() {
	$git_cmd update-index --assume-unchanged "$HOME/setup.sh"
	rm -f "$HOME/setup.sh"
	if [[ "$OSTYPE" != "darwin"* ]]; then
		$git_cmd update-index --assume-unchanged "$HOME/.macos"
		rm -f "$HOME/.macos"
	fi
}

if [[ "$1" == "--clean-only" ]]; then
	clean
else
	setup
	clean
fi
