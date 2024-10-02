fastfetch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"


ZSH_THEME="powerlevel10k/powerlevel10k"

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

alias sudo='sudo ' # allow aliases to sudoed
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotfilesclean='dotfiles restore update-index --no-assume-unchanged "$HOME/setup.sh" && $HOME/setup.sh --clean-only


[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
