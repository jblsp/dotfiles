#!/bin/bash

if [ -d "$HOME/.cfggit" ]; then
	echo "$HOME/.cfggit" already exists."
fi
git clone --separate-git-dir=$HOME/.cfggit https://github.com/jblsp/dotfiles $HOME/dotfiles.tmp
cp -r $HOME/dotfiles.tmp/. $HOME/
rm -rf $HOME/dotfiles.tmp
git --git-dir=$HOME/.cfggit/ --work-tree=$HOME config --local status.showUntrackedFiles no
git --git-dir=$HOME/.cfggit/ --work-tree=$HOME update-index --assume-unchanged README.md install.sh
rm -f $HOME/README.md $HOME/install.sh
