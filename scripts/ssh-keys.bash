#!/usr/bin/env bash
set +x
set -euo pipefail
umask 077

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
destination="$HOME/.ssh/keys"
[[ ! -L "$destination" ]] || { printf 'SSH key directory must not be a symlink\n' >&2; exit 1; }
mkdir -p "$destination"
chmod 700 "$HOME/.ssh" "$destination"
stage=$(mktemp -d "$destination/.install.XXXXXXXX")
trap 'rm -rf -- "$stage"' EXIT

store=$(sops decrypt --output-type json \
  "$root/secrets/ssh-keys.enc.json")
jq_store() { printf '%s' "$store" | jq "$@"; }
jq_store -e 'type == "object" and length > 0 and all(to_entries[];
  (.key | test("^[a-zA-Z0-9_-][a-zA-Z0-9_.-]*\\z") and (endswith(".pub") | not)) and
  (.value | type == "object" and
    (.public | type == "string" and length > 0) and
    (.private | type == "string" and length > 0) and
    (if has("passphrase") then
      (.passphrase | type == "string" and length > 0 and (test("[\u0000\r\n]") | not))
    else true end)))' >/dev/null

while IFS= read -r name; do
  for field in private public; do
    filename="$name"
    [[ "$field" == private ]] || filename="$name.pub"
    [[ ! -d "$destination/$filename" ]] || { printf 'Key path is a directory: %s\n' "$filename" >&2; exit 1; }
    jq_store -j --arg name "$name" --arg field "$field" '.[$name][$field]' > "$stage/$filename"
    if [[ "$field" == public ]]; then chmod 644 "$stage/$filename"; fi
  done
done < <(jq_store -r 'keys[]')

while IFS= read -r name; do
  if jq_store -e --arg name "$name" '.[$name] | has("passphrase")' >/dev/null; then
    passphrase=$(jq_store -r --arg name "$name" '.[$name].passphrase')
    if existing=$(keyring get dotfiles-ssh "$name" 2>/dev/null) && [[ "$existing" == "$passphrase" ]]; then
      continue
    fi
    printf '%s\n' "$passphrase" | keyring set dotfiles-ssh "$name" >/dev/null
  elif keyring get dotfiles-ssh "$name" >/dev/null 2>&1; then
    keyring del dotfiles-ssh "$name" >/dev/null
  fi
done < <(jq_store -r 'keys[]')

while IFS= read -r name; do
  mv -f -- "$stage/$name" "$destination/$name"
  mv -f -- "$stage/$name.pub" "$destination/$name.pub"
done < <(jq_store -r 'keys[]')
