#!/bin/bash

repo_dir="$HOME/.dotfiles.git"
git_cmd="git --git-dir=$repo_dir --work-tree=$HOME"

os_is() {
	local os_name="$1"

	if grep -q "$os_name" /etc/os-release; then
		return 0
	else
		return 1
	fi
}

is_installed() {
	if command -v "$1" >/dev/null 2>&1; then
		return 0
	else
		return 1
	fi
}

install_dependencies() {
	if os_is "Arch"; then
		local dependencies=("git")

		local packages=()
		for dependency in "${dependencies[@]}"; do
			if ! is_installed "$dependency"; then
				packages+=("$dependency")
			fi
		done

		if [ "${#packages[@]}" -gt 0 ]; then
			echo "The following packages will be installed: ${packages[*]}"
			sudo pacman -Sy --noconfirm "${packages[@]}"
		fi

	elif os_is "Darwin"; then
		if ! is_installed "brew"; then
			echo "Missing Homebrew, aborting..."
			exit 1
		fi

		local dependencies=("git")

		local packages=()
		for dependency in "${dependencies[@]}"; do
			if ! is_installed "$dependency"; then
			    packages+=("$dependency")
			fi
		done

		if [ "${#packages[@]}" -gt 0 ]; then
			echo "The following packages will be installed"
			for package in "${packages[@]}"; do
			    echo "$package"
			done
			brew install "${packages[@]}"
		fi
	else
		echo "Unsupported OS, aborting..."
		exit 1
	fi
}

setup() {
	if [ -d "$repo_dir" ]; then
		rm -rf "$repo_dir"
	fi

	git clone --bare https://github.com/jblsp/dotfiles "$repo_dir"
	$git_cmd checkout -f

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
	$git_cmd update-index --assume-unchanged "$HOME/README.md"
	rm -f "$HOME/README.md"
}


if [[ "$1" == "--clean-only" ]]; then
	clean
else
	install_dependencies
	setup
	clean
fi
