#!/usr/bin/env bash

# Utility to handle files read by Mozilla programs that need to be in mozlz4 format
# Requires https://github.com/cions/mozlz4/

for profile_dir in $HOME/.config/mozilla/firefox/profiles/*/; do
  if [[ -f "${profile_dir}search.json" ]]; then
    mozlz4 -z -f "${profile_dir}search.json"
  fi
done
