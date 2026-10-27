#!/usr/bin/env bash
set +x
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
prompt=${1:-}
ssh_prompt="^Enter passphrase for key '(.+)': ?$"
add_prompt='^Enter passphrase for (.+): ?$'
key=''
if [[ ${SSH_ASKPASS_PROMPT:-} == '' ]]; then
  if [[ "$prompt" =~ $ssh_prompt ]]; then
    key=${BASH_REMATCH[1]}
  elif [[ "$prompt" =~ $add_prompt ]]; then
    key=${BASH_REMATCH[1]}
  fi
fi

if [[ -n "$key" && -f "$key" && ! -L "$key" ]]; then
  directory=$(cd -P -- "$(dirname -- "$key")" && pwd)
  managed=$(cd -P -- "$HOME/.ssh/keys" 2>/dev/null && pwd) || managed=''
  name=${key##*/}
  if [[ "$directory" == "$managed" && "$name" =~ ^[a-zA-Z0-9_-][a-zA-Z0-9_.-]*$ && "$name" != *.pub ]]; then
    if passphrase=$(mise -C "$root" exec -- keyring get dotfiles-ssh "$name" 2>/dev/null) && [[ -n "$passphrase" ]]; then
      printf '%s\n' "$passphrase"
      exit 0
    fi
  fi
fi

if [[ -n ${DOTFILES_SSH_ASKPASS_FALLBACK:-} && ! ${DOTFILES_SSH_ASKPASS_FALLBACK} -ef ${BASH_SOURCE[0]} ]]; then
  exec "$DOTFILES_SSH_ASKPASS_FALLBACK" "$@"
fi

exec 3<> /dev/tty
if [[ ${SSH_ASKPASS_PROMPT:-} == none ]]; then
  printf '%s\n' "$prompt" >&3
  exit 0
fi
printf '%s' "$prompt" >&3
if [[ ${SSH_ASKPASS_PROMPT:-} == confirm || "$prompt" == *'(yes/no'* ]]; then
  IFS= read -r answer <&3 || exit 1
  if [[ ${SSH_ASKPASS_PROMPT:-} == confirm && "$answer" != yes ]]; then exit 1; fi
else
  IFS= read -r -s answer <&3 || { printf '\n' >&3; exit 1; }
  printf '\n' >&3
fi
printf '%s\n' "$answer"
