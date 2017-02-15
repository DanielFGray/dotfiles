# vim: ft=sh

if [[ -n "$BASH_VERSION" && -f "$HOME/.bashrc" ]]; then
  source "$HOME/.bashrc"
  IFS=: read -ra current_path <<< "$PATH"
elif [[ -n "$ZSH_VERSION" ]]; then
  IFS=: read -rA current_path <<< "$PATH"
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
  "$HOME/bin"
  "$HOME/.bin"
  "$HOME/.local/bin"
)

for d in "${dirs[@]}"; do
  if [[ -d "$d" && ! " ${current_path[*]} " = *" $d "* ]]; then
    PATH="$d:$PATH"
  fi
done

export PATH

# export PATH="$HOME/.cargo/bin:$PATH"

if has fzf; then
  has ag && export FZF_DEFAULT_COMMAND='ag -l'
  has fnd && export FZF_CTRL_T_COMMAND='fnd -no-hidden'
  has fnd && export FZF_ALT_C_COMMAND='fnd -no-hidden -type d'
  export FZF_DEFAULT_OPTS='--bind="`:jump,Ctrl-d:half-page-down,Ctrl-u:half-page-up" --inline-info --cycle --jump-labels="asdfghjkl;qwertyuiopzxcvbnm1234567890"'
  export FZF_CTRL_R_OPTS='--reverse -e --height='50%' --bind="?:toggle-preview" --preview="echo {}" --preview-window="down:3:wrap:hidden"'
fi

if has rustc racer; then
  export RUST_SRC_PATH="$HOME/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"
fi
