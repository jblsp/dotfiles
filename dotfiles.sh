#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"

can_run() {
  if command -v "$1" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

dots_git() {
  git -C "$DOTFILES" "$@"
}

case "$1" in
install)
  echo "Installing into $DOTFILES"
  dependencies=( "git" "nix" "stow" )
  missing=()

  for dep in "${dependencies[@]}"; do
    if ! can_run "$dep"; then
      missing+=("$dep")
    fi
  done

  if [ ${#missing[@]} -gt 0 ]; then
    echo "Missing dependencies: ${missing[*]}"
    exit 1
  fi

  if [ -d "$DOTFILES" ]; then
    echo "$DOTFILES already exists. Run \`$0 uninstall\` to remove it. Aborting..."
    exit 1
  fi

  if [ -d "$HOME/.config/home-manager" ]; then
    echo "Found existing home-manager configuration. Aborting..."
    exit 1
  fi

  if [ -f "$HOME/.local/bin/dotfiles" ]; then
    echo "Found existing file \`dotfiles\` in ~/.local/bin. Aborting..."
  fi

  git clone https://github.com/jblsp/dotfiles "$DOTFILES"

  cd "$DOTFILES/stow" && stow *

  ln -s "$DOTFILES/home-manager" "$HOME/.config/home-manager"

  mkdir -p "$HOME/.local/bin"
  ln -s "$DOTFILES/dotfiles.sh" "$HOME/.local/bin/dotfiles"
  ;;
uninstall)
  cd "$DOTFILES/stow" && stow --delete * 
  rm -rf "$HOME/.dotfiles"
  rm -rf "$HOME/.local/bin/dotfiles"
  rm -rf "$HOME/.config/home-manager"
  ;;
stow)
  cd "$DOTFILES/stow" && stow "${@:2}"
  ;;
edit)
  if [ -z "$EDITOR" ]; then
    echo "Error: \$EDITOR is not set."
    exit 1
  fi

  cd "$DOTFILES" && "$EDITOR" .
  ;;
git)
  dots_git "${@:2}"
  ;;
flake)
  cd "$DOTFILES/home-manager" && nix flake "${@:2}"
  ;;
*)
  if [ "$1" ]; then
    printf "Unknown command: \`%s %s\`\n\n" "$(basename "$0")" "$1"
    exit 1
  fi
  dots_git fetch
  dots_git status
  ;;
esac

exit 0

# vim: ft=bash
