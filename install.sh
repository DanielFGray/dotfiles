#!/usr/bin/env bash

cd "${BASH_SOURCE%/*}" || exit
declare thisdir="$PWD"
declare verbose
declare -a errors
declare -a configs_avail
declare -a configs_chosen

source "./bash_utils"

err() {
  errors+=( "  $*" )
}

echo_cmd() {
  if (( verbose > 0 )); then
    echo "$*"
    "$@" &>/dev/null
  else
    "$@" &>/dev/null
  fi
}

curl() {
  command curl -s "$@"
}
export -f curl

backup_then_symlink() {
  local f src dest
  for f; do
    src=$(realpath "${thisdir}/${f}")
    dest="$HOME/.${f}"
    if [[ ! -e "$src" ]]; then
      err "$src does not exist"
      break
    fi
    if [[ -e "$dest" && ! -L "$dest" ]]; then
      echo_cmd mv "$dest" "${dest%/*}/old-${dest##*/}"
    fi
    mkdir -p "${dest%/*}/"
    echo_cmd ln -sf "$src" "$dest"
  done
}

library() {
  local repo path flags
  flags=()
  if (( $# != 2 )); then
    err 'library() needs repo and path to clone to'
    return 1
  fi
  case "$1" in
    http*|https*|git*|ssh*) repo="$1" ;;
    *) repo="ssh://git@github.com/danielfgray/$1" ;;
  esac
  path="$2"
  if [[ -d "$path" ]]; then
    if [[ -d "${path}/.git" ]]; then
      echo_cmd git -C "$path" pull
    else
      err "no .git found in ${path}, could not update"
    fi
  fi
  if [[ ! -d "$path" ]]; then
    mkdir ${verbose:+-v} -p "${path%/*}"
    echo_cmd git clone "${flags[@]}" "$repo" "$path"
  fi
}

config_base() {
  backup_then_symlink profile bashrc bash_aliases bash_utils inputrc gitconfig
}

config_scripts() {
  library bin ~/.local/bin
  library api-helper ~/build/api-helper
  library fzf-scripts ~/build/fzf-scripts
  library tekup ~/build/tekup
  library yaxg ~/build/yaxg
  library boiler ~/build/boiler
  find ~/build/{yaxg,boiler,tekup,fzf-scripts,api-helper} -maxdepth 1 -executable -type f -exec ln ${verbose:+-v} -s -t "$HOME/.local/bin" {} \;
}

has -v vim && config_vim() {
  backup_then_symlink vimrc
  mkdir ${verbose:+-v} -p ~/.vim/{autoload,bundle,cache,undo,backups,swaps}
  curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

has -v zsh && config_zsh() {
  backup_then_symlink zsh zshrc zshenv zlogin
  library https://github.com/zdharma/fast-syntax-highlighting ~/.zsh/plugins/fast-syntax-highlighting
  library https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
  library https://github.com/hlissner/zsh-autopair ~/.zsh/plugins/zsh-autopair
}

config_fzf() {
  library https://github.com/junegunn/fzf.git ~/.fzf
  if [[ ! -x ~/.fzf/install ]]; then
    err 'failed to install fzf'
    return 1
  fi
  ~/.fzf/install --all &> /dev/null
}

has -v tmux && config_tmux() {
  backup_then_symlink tmux.conf
  library https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  [[ -x ~/.tmux/plugins/tpm/bin/install_plugins ]] && echo_cmd ~/.tmux/plugins/tpm/bin/install_plugins
}

has -v gem && config_gem() {
  backup_then_symlink gemrc
}

if has -v X; then
  config_x11() {
    has -v startx && backup_then_symlink xinitrc
    has -v xmodmap && backup_then_symlink xmodmap
    has -v xrdb && backup_then_symlink Xresources
    if has -v fc-cache; then
      [[ -f ~/.local/share/fonts/FantasqueSansMono-Regular.ttf ]] && return 0
      mkdir -p ~/.local/share/fonts
      if [[ ! -f ~/downloads/fantasque-sans-mono.zip ]]; then
        echo_cmd curl -L --create-dirs -o ~/downloads/fantasque-sans-mono.zip \
          'https://fontlibrary.org/assets/downloads/fantasque-sans-mono/db52617ba875d08cbd8e080ca3d9f756/fantasque-sans-mono.zip'
      fi
      if ! has -v unzip; then
        err 'downloaded Fantasque Sans Mono but unzip is unavailable'
        return 1
      fi
      if [[ -f ~/downloads/fantasque-sans-mono.zip ]]; then
        echo_cmd unzip ~/downloads/fantasque-sans-mono.zip '*.ttf' -d ~/.local/share/fonts
      else
        err 'failed to download font Fantasque Sans Mono'
      fi
    fi
  }
fi

config_yarn() {
  echo_cmd curl -L https://yarnpkg.com/install.sh | sh
  ~/.yarn/bin/yarn config set init-version 0.0.1
  ~/.yarn/bin/yarn config set init-author-email DanielFGray@gmail.com
  ~/.yarn/bin/yarn config set init-author-name DanielFGray
  ~/.yarn/bin/yarn config set init-license GPL-3.0
}

config_nvm() {
  echo_cmd curl -L https://raw.githubusercontent.com/creationix/nvm/master/install.sh | sh
}

config() {
  has "config_$1" || {
    color red ":: FAILED $1: does not exist"
    return 1
  }
  color blue ":: STARTING $1"
  if "config_$1"; then
    color green ":: FINISHED $1"
  else
    color red ":: FAILED $1"
  fi
}

finish() {
  printf '%s' "$(tput sgr0)"
  exit
}

trap finish SIGHUP SIGINT SIGTERM

while getopts ":hv" opt; do
  case "$opt" in
    h) usage; exit ;;
    v) (( ++verbose )) ;;
  esac
done
shift $(( OPTIND - 1 ))
unset opt OPTARG OPTIND OPTERR

has -v git curl || die 'git and curl both required'

mapfile -t configs_avail < <(compgen -A function | awk '/^config_/{ sub(/^config_/, "", $0); print }')

if in_term && [[ $1 != '--all' ]]; then
  printf 'will install the following groups:\n'
  read -r -e -p '> ' -i "${configs_avail[*]}" -a configs_chosen
else
  configs_chosen=( "${configs_avail[@]}" )
fi

for f in "${configs_chosen[@]}"; do
  (( count++ >= 4 )) && wait -n
  config "$f" &
done
wait

if (( "${#errors[@]}" > 0 )); then
  color red 'The following errors occured'
  color red "${errors[@]}"
else
  color green 'success!'
fi

finish
