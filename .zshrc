fastfetch

export ZSH="$HOME/.oh-my-zsh"

zstyle ':omz:update' mode auto
zstyle ':omz:update' verbosity minimal

plugins=(
  nvm
  git
  gh
  sudo
  colored-man-pages
  gitignore
  command-not-found
  zsh-autosuggestions
  zsh-syntax-highlighting
  you-should-use
)

ZSH_THEME="powerlevel10k/powerlevel10k"

source $ZSH/oh-my-zsh.sh
source ~/.p10k.zsh

# Brew
if [[ "$(uname)" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Exports
export LANG=en_US.UTF-8
export EDITOR=$([[ -n $SSH_CONNECTION ]] && echo "vim" || echo "nvim")

# Aliases
alias sudo='sudo '
alias ff='fastfetch'
alias c='clear'
alias fuck='sudo $SHELL -c "$(fc -ln -1)"'
alias waybarrestart='pkill waybar && hyprctl dispatch exec waybar'

# Functions
dotfiles() {
	clean() {
		git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME restore $HOME/setup.sh
		git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME update-index --no-assume-unchanged $HOME/setup.sh
		$HOME/setup.sh --clean-only
	}
	
	if [ -z "$1" ]; then
		git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME status
		return 1
	fi

	case $1 in
		"clean")
			clean
			;;
		"update")
			git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME pull
			clean
			;;
		*)
			git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME $@
	esac
}

