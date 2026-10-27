#!/usr/bin/env bash
set +x
set -euo pipefail

fail() { printf 'template-secrets.bash: %s\n' "$1" >&2; exit 1; }
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)

case "${1:-}" in
  get)
    store="$root/secrets/templates.enc.json"
    # Buffer authenticated output before emitting plaintext, including trailing newlines.
    value=$(
      sops decrypt --output-type json "$store" |
        jq -j --arg name "$2" '.[$name]' || exit 1
      printf '.'
    ) || fail 'secret unavailable or store invalid'
    printf '%s' "${value%.}"
    ;;
  *) fail 'usage: template-secrets.bash get NAME' ;;
esac
