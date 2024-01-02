# vim: ft=sh

has() {
  for c; do
    command -v "$c" &> /dev/null || return 1
  done
}

dirs=()

# has cope_path && dirs+=( "$(cope_path)" )
# has ruby gem && dirs+=( "$(ruby -e 'print Gem.user_dir')/bin" )
dirs+=(
  "$HOME/.rakudobrew/bin"
  "$HOME/.rvm/bin"
  "$HOME/.npm/bin"
  "$HOME/.yarn/bin"
  "$HOME/.cabal/bin"
  "$HOME/.cargo/bin"
  "$HOME/.go/bin"
  "$HOME/.perlbrew/bin"
  "$HOME/.local/bin"
  # "$HOME/.bin"
  # "$HOME/bin"
)

for d in "${dirs[@]}"; do
  if [[ -d "$d" && ! ":${PATH}:" = *":$d:"* ]]; then
    PATH="$d:$PATH"
  fi
done

export PATH

if has fzf; then
  if has fd; then
    export FZF_DEFAULT_COMMAND='fd'
    export FZF_CTRL_T_COMMAND='fd -t f'
    export FZF_ALT_C_COMMAND='fd -t d'
  elif has fnd; then
    export FZF_DEFAULT_COMMAND='fnd -no-hidden'
    export FZF_CTRL_T_COMMAND='fnd -no-hidden'
    export FZF_ALT_C_COMMAND='fd -no-hidden -type d'
  fi
  export FZF_DEFAULT_OPTS='--bind="Ctrl-A:toggle-all,`:jump" --height=90% --reverse --ansi +s -e --inline-info --cycle --jump-labels="asdfghjklzxcvbnmqwertyuiop"'
  export FZF_CTRL_R_OPTS='--bind="?:toggle-preview" --preview="echo {}" --preview-window="down:3:wrap:hidden"'
  export FZF_ALT_C_OPTS="--preview='ls -R {}'"
fi

if has sk; then
  export SKIM_DEFAULT_OPTIONS='--ansi --cycle --height=80% --reverse'
fi

# if has rustc racer; then
#   export RUST_SRC_PATH="$HOME/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"
# fi

if has x-www-browser; then
  export BROWSER='x-www-browser'
fi

if has qt5ct; then
  export QT_QPA_PLATFORMTHEME="qt5ct"
fi

if [[ -n "$BASH_VERSION" && -f "$HOME/.bashrc" ]]; then
  source "$HOME/.bashrc"
fi

# 
