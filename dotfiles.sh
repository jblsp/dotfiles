#!/usr/bin/env bash
# vim: ft=bash

if [ -z "$DOTFILES" ]; then
  DOTFILES="$HOME/.dotfiles"
fi

can_run() {
  if command -v "$1" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

remove_if_exists() {
  if [ -e "$1" ]; then
    rm -rf "$1"
    echo "Removed $1."
  fi
}

stow_configs() {
  for dir in "$DOTFILES/stow"/*; do
    stow --dir="$DOTFILES/stow" --target="$HOME" "$(basename "$dir")"
  done

}

dots_git() {
  git -C "$EDITOR" "$@"
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

  stow_configs

  mkdir "$HOME/.config/home-manager"
  stow --dir="$DOTFILES" --target="$HOME/.config/home-manager" "home-manager"

  mkdir -p "$HOME/.local/bin"
  ln -s "$DOTFILES/dotfiles.sh" "$HOME/.local/bin/dotfiles"

  nix run home-manager/master switch
  ;;
uninstall)
  if can_run "home-manager"; then
    nix run home-manager/master uninstall
  fi

  if [ -d "$DOTFILES/stow" ]; then
    stow --dir="$DOTFILES/stow" -D "$(ls "$DOTFILES/stow")"
    echo "Deleted packages in $DOTFILES/stow"
  fi
  if [ -d "$DOTFILES/home-manager" ]; then
    rm -r "$HOME/.config/home-manager"
    stow -d "$DOTFILES" -D "home-manager"
    echo "Deleted home-manager stow package at $DOTFILES/home-manager"
  fi
  remove_if_exists "$HOME/.local/bin/dotfiles"
  remove_if_exists "$HOME/.dotfiles"
  ;;
stow)
  stow_configs
  ;;
edit)
  if [ -z "$EDITOR" ]; then
    echo "Error: \$EDITOR is not set."
    exit 1
  fi

  "$EDITOR" "$DOTFILES"
  ;;
git)
  dots_git "${@:2}"
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
