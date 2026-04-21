#!/usr/bin/env bash

# Utility to symlink configurations to "relocate" them.
# ex: move firefox config on macos from application support/firefox to ~/.config/mozilla/firefox

relocate_config() {
  local src="$1"
  local dst="$2"

  # Move if real dir and dst missing
  if [[ -e "$src" && ! -L "$src" && ! -e "$dst" ]]; then
    mv "$src" "$dst"
  fi

  # Ensure dst exists
  mkdir -p "$dst"

  # Add symlink if missing or wrong
  if [[ ! -L "$src" || "$(readlink "$src")" != "$dst" ]]; then
    # Backup src
    if [[ -e "$src" || -L "$src" ]]; then
      mv "$src" "${src}.bak.$(date +%Y%m%d%H%M%S)"
    fi
    ln -s "$dst" "$src"
  fi
}

if [[ "$(uname)" == "Darwin" ]]; then
  relocate_config "$HOME/Library/Application Support/Firefox" "$HOME/.config/mozilla/firefox"
fi
