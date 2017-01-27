#!/usr/bin/env bash

cd "${BASH_SOURCE%/*}" || exit
declare thisdir="$PWD"
declare verbose

source "${thisdir}/bash_utils"

echo_cmd() {
  echo "$*"
  "$@"
}

backup_then_symlink() {
  local f src dest
  for f; do
    src=$( realpath "${thisdir}/${f}" )
    dest="$HOME/.${f}"
    if [[ ! -e "$src" ]]; then
      err "$src does not exist"
      break;
    fi
    if [[ -L "$dest" ]]; then
      rm ${verbose:+-v} "$dest"
    fi
    if [[ -e "$dest" ]]; then
      mv ${verbose:+-v} "$dest" "${dest%/*}/old-${dest##*/}"
    fi
    mkdir ${verbose:+-v} -p "${dest%/*}/" && ln ${verbose:+-v} -s "$src" "$dest"
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
    mkdir -p ${verbose:+-v} "${path%/*}"
    echo_cmd git clone "$repo" "$path"
  fi
}

finish() {
  info 'done. you should probably log out'
}

trap finish SIGHUP SIGINT SIGTERM

while true; do
  case "$1" in
    -v|--verbose) verbose=true ;;
    *) break ;;
  esac
  shift
done

has -v git curl || die 'git and curl both required'

backup_then_symlink profile bash_aliases bash_utils inputrc gitconfig

library danielfgray/bin "$HOME/.local/bin"

if has -v vim; then
  backup_then_symlink vimrc
fi

if has -v zsh; then
  backup_then_symlink zsh zshrc zshenv zlogin
  library robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"
  library zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
  library zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

library junegunn/fzf.git "$HOME/.fzf"
if [[ -x ~/.fzf/install ]]; then
  ~/.fzf/install --all
  library danielfgray/fzf-scripts "$HOME/build/fzf-scripts"
else
  err 'failed to install fzf'
fi

if has -v tmux; then
  backup_then_symlink tmux.conf
  library tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if has -v gem; then
  backup_then_symlink gemrc
fi

if has -v X; then
  if has -v startx; then
    backup_then_symlink xinitrc
  fi

  if has -v xmodmap; then
    backup_then_symlink xmodmap
  fi

  if has -v xrdb; then
    backup_then_symlink Xresources
  fi

  if [[ ! -f "$HOME/.local/share/fonts/FantasqueSansMono-Regular.ttf"  ]]; then
    mkdir -p "$HOME/.local/share/fonts"
    if [[ ! -f "$HOME/downloads/fantasque-sans-mono.zip" ]]; then
      curl  -L -o "$HOME/downloads/fantasque-sans-mono.zip" --create-dirs \
        'https://fontlibrary.org/assets/downloads/fantasque-sans-mono/db52617ba875d08cbd8e080ca3d9f756/fantasque-sans-mono.zip'
    fi
    if [[ -f "$HOME/downloads/fantasque-sans-mono.zip" ]]; then
      unzip "$HOME/downloads/fantasque-sans-mono.zip" '*.ttf' -d "$HOME/.local/share/fonts"
    else
      err 'failed to download font Fantasque Sans Mono'
    fi
  fi
fi

finish
