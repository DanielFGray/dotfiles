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
  local flags
  flags=()
  case "$verbose" in
    ''|0) flags+=('-s') ;;
    2|3) flags+=('-v') ;;
  esac
  command curl "${flags[@]}" "$@"
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
    *) repo="https://github.com/$1" ;;
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
  library danielfgray/bin ~/.local/bin
}

config_vim() {
  has -v vim || return 1
  backup_then_symlink vimrc
  mkdir ${verbose:+-v} -p ~/.vim/{autoload,bundle,cache,undo,backups,swaps}
  curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  (( verbose > 0 )) && echo 'installing vim plugins'
  vim -c PlugInstall -c 'quitall!' -e &> /dev/null
  if (( verbose > 0 )); then echo 'finished vim plugins'; fi
}

config_zsh() {
  has -v zsh || return 1
  backup_then_symlink zsh zshrc zshenv zlogin
  library robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  library zdharma/fast-syntax-highlighting ~/.zsh/plugins/fast-syntax-highlighting
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
  [[ -x ~/.tmux/plugins/tpm/bin/install_plugins ]] && echo_cmd ~/.tmux/plugins/tpm/bin/install_plugins
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
  if ! has -v unzip; then
    err 'downloaded Fantasque Sans Mono but unzip is unavailable'
    return 1
  fi
  if [[ -f ~/downloads/fantasque-sans-mono.zip ]]; then
    echo_cmd unzip ~/downloads/fantasque-sans-mono.zip '*.ttf' -d ~/.local/share/fonts
  else
    err 'failed to download font Fantasque Sans Mono'
  fi
}

config_yarn() {
  echo_cmd curl -L https://yarnpkg.com/install.sh | sh
}

config_nvm() {
  echo_cmd curl -L https://raw.githubusercontent.com/creationix/nvm/master/install.sh | sh
}

config() {
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

mapfile -t configs_avail < <(compgen -A function | perl -lne 'print $1 if /config_(.*)/')

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
