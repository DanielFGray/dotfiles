# vim: ft=sh

if [[ -n "$BASH_VERSION" && -f "$HOME/.bashrc" ]]; then
  source "$HOME/.bashrc"
fi

has() {
  for c; do
    command -v "$c" &> /dev/null || return 1
  done
}

dirs=()

has cope_path && dirs+=( "$(cope_path)" )
has ruby gem && dirs+=( "$(ruby -e 'print Gem.user_dir')/bin" )
dirs+=(
  "$HOME/.rakudobrew/bin"
  "$HOME/.rvm/bin"
  "$HOME/.npm/bin"
  "$HOME/.yarn/bin"
  "$HOME/.cabal/bin"
  "$HOME/.cargo/bin"
  "$HOME/.go/bin"
  "$HOME/.perlbrew/bin"
  "$HOME/bin"
  "$HOME/.bin"
  "$HOME/.local/bin"
)

for d in "${dirs[@]}"; do
  if [[ -d "$d" && ! ":${PATH}:" = *":$d:"* ]]; then
    PATH="$d:$PATH"
  fi
done

export PATH

if has fzf; then
  has fnd && {
    export FZF_DEFAULT_COMMAND='fnd -no-hidden'
    export FZF_CTRL_T_COMMAND='fnd -no-hidden'
    export FZF_ALT_C_COMMAND='fnd -no-hidden -type d'
  }
  export FZF_DEFAULT_OPTS='--bind="Ctrl-A:toggle-all,`:jump" --ansi --layout=reverse +s -e --inline-info --cycle --jump-labels="asdfghjklzxcvbnmqwertyuiop"'
  export FZF_CTRL_R_OPTS='--bind="?:toggle-preview" --preview="echo {}" --preview-window="down:3:wrap:hidden"'
fi

if has rustc racer; then
  export RUST_SRC_PATH="$HOME/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"
fi

if has x-www-browser; then
  export BROWSER='x-www-browser'
fi

# export PATH="$HOME/.cargo/bin:$PATH"
