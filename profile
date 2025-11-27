# vim: ft=sh

select_from() {
  local o c cmd OPTARG OPTIND
  cmd='command -v'
  while getopts 'c:' o; do
    case "$o" in
    c) cmd="$OPTARG" ;;
    esac
  done
  shift "$((OPTIND - 1))"
  for c; do
    if $cmd "${c%% *}" &>/dev/null; then
      echo "$c"
      return 0
    fi
  done
  return 1
}

has() {
  for c; do
    command -v "$c" &>/dev/null || return 1
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
  "$HOME/.bun/bin"
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
    export FZF_DEFAULT_COMMAND='fd --color=always'
    export FZF_CTRL_T_COMMAND='fd --color=always -t f'
    export FZF_ALT_C_COMMAND='fd --color=always -t d'
  elif has fnd; then
    export FZF_DEFAULT_COMMAND='fnd -no-hidden'
    export FZF_CTRL_T_COMMAND='fnd -no-hidden'
    export FZF_ALT_C_COMMAND='fd -no-hidden -type d'
  fi
  export FZF_DEFAULT_OPTS='--bind="Ctrl-A:toggle-all,`:jump" --reverse --ansi +s -e --inline-info --cycle --jump-labels="asdfghjklzxcvbnmqwertyuiop"'
  export FZF_CTRL_R_OPTS='--bind="?:toggle-preview" --preview="echo {}" --preview-window="down:3:wrap:hidden"'
  export FZF_ALT_C_OPTS="--preview='$(select_from 'fd --color=always .' fnd 'ls -R') {}'"
fi

if has sk; then
  export SKIM_DEFAULT_OPTIONS='--ansi --cycle --reverse'
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
