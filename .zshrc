# Set up zim
zstyle ':zim:zmodule' use 'degit'
ZIM_CONFIG_FILE=~/.config/zim/.zimrc
ZIM_HOME=~/.local/share/zim
if [ ! -d "$ZIM_HOME" ]; then
    mkdir -p "$ZIM_HOME"
fi
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# Initialize modules.
source ${ZIM_HOME}/init.zsh

# Exports
export LANG=en_US.UTF-8
export EDITOR=$([[ -n $SSH_CONNECTION ]] && echo "vim" || echo "nvim")

# Aliases
alias sudo='sudo '
alias ff='fastfetch'
alias c='clear'

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


