# XDG base dirs
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
if [[ "$OSTYPE" == darwin* ]]; then
  XDG_RUNTIME_DIR=$(getconf DARWIN_USER_TEMP_DIR)
else
  XDG_RUNTIME_DIR=/run/user/$(id -u)
fi

# Default programs
export EDITOR="nvim"
export MANPAGER="nvim +Man!"

# zsh
export SHELL_SESSIONS_DISABLE=1

# bash
export HISTFILE="${XDG_STATE_HOME}"/bash/history

if [[ "$OSTYPE" == darwin* ]]; then
  # fix java on mac
  export JAVA_HOME=/opt/homebrew/opt/java

  # homebrew
  export HOMEBREW_NO_ENV_HINTS=1
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_NO_UPDATE_REPORT_NEW=1
fi

# go
export GOPATH="$XDG_DATA_HOME/go"

# npm
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

# node
export NODE_REPL_HISTORY="$XDG_STATE_HOME"/node_repl_history

# bitwarden
export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
if [[ "$OSTYPE" == darwin* && -S "$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock" ]]; then
  export SSH_AUTH_SOCK="$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
elif [[ "$OSTYPE" == linux* ]]; then
  for socket in "$HOME/snap/bitwarden/current/.bitwarden-ssh-agent.sock" "$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"; do
    if [[ -S "$socket" ]]; then
      export SSH_AUTH_SOCK="$socket"
      break
    fi
  done
fi

# docker
# disabled because macos docker desktop does not use this var
# export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker

# disable telemetry
export DISABLE_TELEMETRY=1
export DO_NOT_TRACK=1

# nvm
export NVM_DIR="$XDG_DATA_HOME/nvm"
export NVM_LAZY_LOAD=true
# export NVM_COMPLETION=true
export NVM_SYMLINK_CURRENT="true"

# python
export PYTHON_HISTORY=$XDG_STATE_HOME/python_history
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python

# codex
export CODEX_HOME="$XDG_CONFIG_HOME"/codex

# claude code
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME"/claude

# cargo
export CARGO_HOME="$XDG_DATA_HOME"/cargo

# rustup
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

# cocoapods
export CP_HOME_DIR="$XDG_DATA_HOME"/cocoapods

# path
path+=("$HOME/.local/bin")
path+=("$GOPATH/bin")
path+=("$HOME/.local/share/npm/bin")
export path

# vim: ft=zsh
