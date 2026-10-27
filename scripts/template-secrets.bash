#!/usr/bin/env bash
set +x
set -euo pipefail

fail() { printf 'template-secrets.bash: %s\n' "$1" >&2; exit 1; }
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)

case "${1:-}" in
  import-key)
    if keyring get dotfiles age-identity >/dev/null 2>&1; then
      [[ ${2:-} == --if-missing ]] && exit 0
      fail 'identity already exists; refusing to overwrite'
    fi
    identity=$(age --decrypt "$root/secrets/key.txt.age") || fail 'identity import failed'
    printf '%s\n' "$identity" | keyring set dotfiles age-identity >/dev/null 2>&1 || fail 'could not store identity in keyring'
    ;;
  get)
    store="$root/secrets/templates.enc.json"
    # Buffer authenticated output before emitting plaintext, including trailing newlines.
    value=$(
      SOPS_AGE_KEY_CMD="keyring get dotfiles age-identity" sops decrypt --output-type json "$store" 2>/dev/null |
        jq -j --arg name "$2" '.[$name]' || exit 1
      printf '.'
    ) || fail 'secret unavailable or store invalid'
    printf '%s' "${value%.}"
    ;;
  *) fail 'usage: template-secrets.bash {import-key [--if-missing]|get NAME}' ;;
esac
