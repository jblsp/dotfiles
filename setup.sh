#!/bin/bash

repo_dir="$HOME/.dotfiles.git"
git_cmd="git --git-dir=$repo_dir --work-tree=$HOME"

setup() {
	if [ -d "$repo_dir" ]; then
		rm -rf "$repo_dir"
	fi

	git clone --bare https://github.com/jblsp/dotfiles "$repo_dir"
	$git_cmd checkout -f
	
	if [ -d "$HOME/.gitmodules" ]; then
		submodule_paths=$(grep 'path = ' "$HOME/.gitmodules" | sed 's/.*= //')
		for submodule_path in $submodule_paths; do
			full_path="$HOME/$submodule_path"
			if [ -d "$full_path" ]; then
				rm -rf "$full_path"
			fi
		done
		$git_cmd submodule update --init --recursive
	fi
	
	$git_cmd push --set-upstream origin main
	$git_cmd config --local status.showUntrackedFiles no
}

clean() {
	$git_cmd update-index --assume-unchanged "$HOME/setup.sh"
	rm -f "$HOME/setup.sh"
	$git_cmd update-index --assume-unchanged "$HOME/README.md"
	rm -f "$HOME/README.md"
}

if ! command -v git >/dev/null 2>&1; then
	echo "git not found. Aborting..."
	exit 1
fi

if [[ "$1" == "--clean-only" ]]; then
	clean
	exit 0
fi

setup
clean
