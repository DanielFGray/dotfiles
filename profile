#!/usr/bin/env bash

if [[ -n "$BASH_VERSION" ]]; then
  if [[ -f "$HOME/.bashrc" ]]; then
    source "$HOME/.bashrc"
  fi
fi

dirs=(
  "/bin"
  "/sbin"
  "/usr/bin"
  "/usr/sbin"
  "/usr/local/bin"
  "/usr/local/sbin"
  "/usr/games"
  "/usr/local/games"
  "$HOME/.rakudobrew/bin"
  "$HOME/.rvm/bin"
  "$(ruby -e 'print Gem.user_dir')/bin"
  "$HOME/.npm/bin"
  "$HOME/.cabal/bin"
  "$HOME/.local/bin"
)

export PATH=''
for d in "${dirs[@]}"; do
  if [[ -d "$d" ]]; then
    PATH="$d:$PATH"
  fi
done

export PATH

# vim: ft=sh
