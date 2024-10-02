fastfetch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

zstyle ':omz:update' mode auto

plugins=(
  git
  sudo
  colored-man-pages
  gitignore
  command-not-found
  nvm
  zsh-autosuggestions
  zsh-syntax-highlighting
  you-should-use
)

ZSH_THEME="powerlevel10k/powerlevel10k"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source $ZSH/oh-my-zsh.sh

if infocmp alacritty &> /dev/null; then
    export TERM="alacritty"
else
    export TERM="xterm-256color"
fi
export LANG=en_US.UTF-8

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

alias sudo='sudo '

dotfiles() {
	clean() {
		git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME restore $HOME/setup.sh
		git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME update-index --no-assume-unchanged $HOME/setup.sh
		$HOME/setup.sh --clean-only
	}
	
	if [ -z "$1" ]; then
		echo "Usage: dotfiles {clean|update|<git-command>}"
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
			git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME $1
	esac
}
