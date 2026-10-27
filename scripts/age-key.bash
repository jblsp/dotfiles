#!/usr/bin/env bash
set +x
set -euo pipefail

fail() { printf 'age-key.bash: %s\n' "$1" >&2; exit 1; }
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)

if ! identity=$(keyring get dotfiles age-identity) || [[ -z "$identity" ]]; then
  identity=$(age --decrypt "$root/secrets/key.txt.age" </dev/tty 2>/dev/tty) || fail 'identity import failed; bootstrap stopped'
  [[ -n "$identity" ]] || fail 'decrypted identity is empty; bootstrap stopped'
  printf '%s\n' "$identity" | keyring set dotfiles age-identity >/dev/null || fail 'could not store identity in keyring; bootstrap stopped'
  stored_identity=$(keyring get dotfiles age-identity) || fail 'could not read imported identity from keyring; bootstrap stopped'
  [[ "$stored_identity" == "$identity" ]] || fail 'imported identity could not be verified in keyring; bootstrap stopped'
fi

if [[ ${1:-} == --print ]]; then
  printf '%s\n' "$identity"
  exit 0
fi

for store in templates ssh-keys; do
  SOPS_AGE_KEY_CMD="keyring get dotfiles age-identity" sops decrypt --output-type json \
    "$root/secrets/$store.enc.json" >/dev/null || fail "cannot decrypt $store store with the keyring identity; bootstrap stopped"
done
