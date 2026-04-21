#!/usr/bin/env bash

# Utility to handle files read by Mozilla programs that need to be in mozlz4 format

for profile_dir in $HOME/.config/mozilla/firefox/profiles/*/; do
  if [[ -f "${profile_dir}search.json" ]]; then
    mozlz4 -z -f "${profile_dir}search.json"
  fi
done
