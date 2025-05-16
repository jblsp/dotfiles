#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"

can_run() {
  if command -v "$1" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

dots_stow() {
  cd "$DOTFILES/stow" && stow "$@"
}

dots_git() {
  git -C "$DOTFILES" "$@"
}

case "$1" in
install)
  echo "Installing into $DOTFILES"
  dependencies=("git" "nix" "stow" "curl")
  missing=()

  for dep in "${dependencies[@]}"; do
    if ! can_run "$dep"; then
      missing+=("$dep")
    fi
  done

  for dep in "${missing[@]}"; do
    case "$dep" in
    "nix")
      read -r -p "Nix is missing, would you like to run the Determinate Nix Installer? [y/N]: " confirm
      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
      fi
      ;;
    esac

    if can_run "$dep"; then
      missing=("${missing[@]/$dep/}")
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

  dots_stow "*"

  ln -s "$DOTFILES/home-manager" "$HOME/.config/home-manager"

  mkdir -p "$HOME/.local/bin"
  ln -s "$DOTFILES/dotfiles.sh" "$HOME/.local/bin/dotfiles"
  ;;
uninstall)
  nix run home-manager/master uninstall

  if [ -e "$HOME/.dotfiles" ]; then
    rm -rf "$HOME/.dotfiles"
  fi
  if [ -e "$HOME/.local/bin/dotfiles" ]; then
    rm -rf "$HOME/.local/bin/dotfiles"
  fi
  if [ -d "$DOTFILES/home-manager" ]; then
    rm -r "$HOME/.config/home-manager"
  fi

  for item in "$HOME/.config"/* "$HOME/.config"/.*; do
    if [ -L "$item" ] && [ ! -e "$item" ]; then
      rm "$item"
    fi
  done

  ;;
stow)
  dots_stow "${@:2}"
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
