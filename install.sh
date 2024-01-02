#!/usr/bin/env bash

cd "${BASH_SOURCE%/*}" || exit
declare thisdir="$PWD"
declare verbose
declare -a errors
declare -a configs_avail
declare -a configs_chosen
declare -a args
declare process=4

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

mkd() {
  mkdir ${verbose:+-v} -p "$@" || die 'failed to mkdir $*'
}

install_dots() {
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
    echo_cmd ln ${verbose:+-v} -s "$src" "$dest"
  done
}

library() {
  local repo path flags
  flags=()
  if (( $# < 2 )); then
    err 'library() needs repo and path to clone to'
    return 1
  fi
  case "$1" in
    http*|https*|git*|ssh*) repo="$1" ;;
    *) repo="ssh://git@github.com/danielfgray/$1" ;;
  esac
  path="$2"
  shift 2
  flags+=( "$@" )
  if [[ -d "$path" ]]; then
    if [[ -d "${path}/.git" ]]; then
      echo_cmd git -C "$path" pull
    else
      err "no .git found in ${path}, could not update"
    fi
  fi
  if [[ ! -d "$path" ]]; then
    mkd "${path%/*}"
    echo_cmd git clone "${flags[@]}" "$repo" "$path"
  fi
}

config_base() {
  install_dots profile bashrc bash_aliases bash_utils inputrc gitconfig
}

config_scripts() {
  library bin ~/.local/bin
  library api-helper ~/build/api-helper
  library fzf-scripts ~/build/fzf-scripts
  library yaxg ~/build/yaxg
  mkd ~/.local/bin
  find ~/build/{yaxg,fzf-scripts,api-helper} -maxdepth 1 -executable -type f -exec ln ${verbose:+-v} -s -t "$HOME/.local/bin" {} \;
}

has vim && config_vim() {
  install_dots vimrc
  mkdir ${verbose:+-v} -p ~/.vim/{autoload,bundle,cache,undo,backups,swaps}
  curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim +PlugInstall +qa &> /dev/null
}

has nvim && config_neovim() {
  if [[ ! -e ~/.config/nvim ]]; then
    ln -s ~/.vim ~/.config/nvim
    ln -s ~/.vimrc ~/.config/nvim/init.lua
  fi
}

has zsh && config_zsh() {
  install_dots zsh zshrc zshenv zlogin
}

has fzf || config_fzf() {
  library https://github.com/junegunn/fzf.git ~/.fzf
  if [[ ! -x ~/.fzf/install ]]; then
    err 'failed to install fzf'
    return 1
  fi
  ~/.fzf/install --all &> /dev/null
}

has tmux && config_tmux() {
  install_dots tmux.conf
  library https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  [[ -x ~/.tmux/plugins/tpm/bin/install_plugins ]] && echo_cmd ~/.tmux/plugins/tpm/bin/install_plugins
}


has gem && config_gem() {
  install_dots gemrc
}

has X && config_x11() {
  has -v startx && install_dots xinitrc
  has -v xmodmap && install_dots xmodmap
  has -v xrdb && install_dots Xresources
  # if has -v fc-cache; then
  #   [[ -f ~/.local/share/fonts/FantasqueSansMono-Regular.ttf ]] && return 0
  #   mkdir -p ~/.local/share/fonts
  #   if [[ ! -f ~/downloads/fantasque-sans-mono.zip ]]; then
  #     echo_cmd curl -L --create-dirs -o ~/downloads/fantasque-sans-mono.zip \
  #       'https://fontlibrary.org/assets/downloads/fantasque-sans-mono/db52617ba875d08cbd8e080ca3d9f756/fantasque-sans-mono.zip'
  #   fi
  #   if ! has -v unzip; then
  #     err 'downloaded Fantasque Sans Mono but unzip is unavailable'
  #     return 1
  #   fi
  #   if [[ -f ~/downloads/fantasque-sans-mono.zip ]]; then
  #     echo_cmd unzip ~/downloads/fantasque-sans-mono.zip '*.ttf' -d ~/.local/share/fonts
  #   else
  #     err 'failed to download font Fantasque Sans Mono'
  #   fi
  # fi
}

has yarn || config_yarn() {
  echo_cmd curl -L https://yarnpkg.com/install.sh | bash
  ~/.yarn/bin/yarn config set init-version 0.0.1
  ~/.yarn/bin/yarn config set init-author-email DanielFGray@gmail.com
  ~/.yarn/bin/yarn config set init-author-name DanielFGray
  ~/.yarn/bin/yarn config set init-license GPL-3.0
}

has n || config_n() {
  echo_cmd curl -L https://raw.githubusercontent.com/creationix/nvm/master/install.sh | sh
}

config() {
  has "config_$1" || {
    err ":: FAILED $1: does not exist"
    return 1
  }
  color blue ":: STARTING $1"
  if "config_$1"; then
    color green ":: FINISHED $1"
  else
    err ":: FAILED $1"
  fi
}

finish() {
  tput sgr0
  exit
}

trap finish SIGHUP SIGINT SIGTERM

while getopts ":hvp:" opt; do
  case "$opt" in
    h) usage; exit ;;
    v) (( ++verbose )) ;;
    p) process="$OPTARG" ;;
  esac
done
shift $(( OPTIND - 1 ))
unset opt OPTARG OPTIND OPTERR

mapfile -t configs_avail < <(compgen -A function | awk '/^config_/{ sub(/^config_/, "", $0); print }')

if [[ $1 = '--all' ]]; then
  configs_chosen=( "${configs_avail[@]}" )
else
  printf 'will install the following groups:\n'
  read -r -e -p '> ' -i "${configs_avail[*]}" -a configs_chosen
fi

(( ${#configs_chosen[@]} > 0 )) || die

for f in "${configs_chosen[@]}"; do
  (( count++ >= process )) && wait -n
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
