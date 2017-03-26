#!/usr/bin/env bash

cd "${BASH_SOURCE%/*}" || exit
declare thisdir="$PWD"
declare verbose=0

source "${thisdir}/bash_utils"

err() {
  printf "${c_red}%s${c_reset}\n" "$*" >&2
}

echo_cmd() {
  (( verbose > 0 )) && echo "$*"
  "$@"
}

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
  local repo path
  if (( $# != 2 )); then
    err 'library() needs repo and path to clone to'
    return 1
  fi
  case "$1" in
    http*|https*|git*|ssh*) repo="$1" ;;
    *) repo="https://github.com/$1" ;;
  esac
  path="$2"
  if [[ -d "$path" ]]; then
    if [[ -d "${path}/.git" ]]; then
      echo_cmd git -C "$path" pull
    elif ask "no .git found in ${path}, delete entire folder and clone repo?"; then
      rm -fr ${verbose:+-v} "$path"
    fi
  fi
  if [[ ! -d "$path" ]]; then
    mkdir ${verbose:+-v} -p "${path%/*}"
    echo_cmd git clone "$repo" "$path"
  fi
}

finish() {
  echo 'done. you should probably log out'
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

config_base() {
  backup_then_symlink profile bashrc bash_aliases bash_utils inputrc gitconfig
  library danielfgray/bin ~/.local/bin
}

config_vim() {
  has -v vim || return 1
  backup_then_symlink vimrc
}

config_zsh() {
  has -v zsh || return 1
  backup_then_symlink zsh zshrc zshenv zlogin
  library robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  library zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting
  library zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
}

config_fzf() {
  library junegunn/fzf.git ~/.fzf
  if [[ -x ~/.fzf/install ]]; then
    ~/.fzf/install --all &> /dev/null
    library danielfgray/fzf-scripts ~/build/fzf-scripts
  else
    err 'failed to install fzf'
    return 1
  fi
}

config_tmux() {
  has -v tmux || return 1
  backup_then_symlink tmux.conf
  library tmux-plugins/tpm ~/.tmux/plugins/tpm
}

config_gem() {
  has -v gem || return 1
  backup_then_symlink gemrc
}

config_x11() {
  has -v X || return 1
  has -v startx && backup_then_symlink xinitrc
  has -v xmodmap && backup_then_symlink xmodmap
  has -v xrdb && backup_then_symlink Xresources
  has -v fc-cache && config_font
}

config_font() {
  [[ -f ~/.local/share/fonts/FantasqueSansMono-Regular.ttf ]] && return 0
  mkdir -p ~/.local/share/fonts
  if [[ ! -f ~/downloads/fantasque-sans-mono.zip ]]; then
    echo_cmd curl -L --create-dirs -o ~/downloads/fantasque-sans-mono.zip \
      'https://fontlibrary.org/assets/downloads/fantasque-sans-mono/db52617ba875d08cbd8e080ca3d9f756/fantasque-sans-mono.zip'
  fi
  has -v unzip || return 1
  if [[ -f ~/downloads/fantasque-sans-mono.zip ]]; then
    echo_cmd unzip ~/downloads/fantasque-sans-mono.zip '*.ttf' -d ~/.local/share/fonts
  else
    err 'failed to download font Fantasque Sans Mono'
  fi
}

config() {
  printf '\e[32mSTARTING %s\e[0m\n' "$1"
  if "config_$1"; then
    printf '\e[34mFINISHED %s\e[0m\n' "$1"
  else
    printf '\e[31mFAILED %s\e[0m\n' "$1"
  fi
}

config=(
  base
  vim
  zsh
  fzf
  tmux
  gem
  x11
  font
)

for c in "${config[@]}"; do
  export -f "config_$c"
done
export verbose
export thisdir
export -f has
export -f backup_then_symlink
export -f library
export -f prompt
export -f err
export -f echo_cmd
export -f config

printf '%s\n' "${config[@]}" | xargs -P4 -I% bash -c 'config %'

finish
