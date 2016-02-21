#!/usr/bin/env bash

cd "${BASH_SOURCE%/*}" || exit
declare thisdir="$PWD"
declare verbose

source "${thisdir}/bash_utils"

echo-cmd() {
  echo "$*"
  $*
}

backup_then_symlink() {
  for f in "$@"; do
    src=$( realpath "${thisdir}/${f}" )
    dest="${HOME}/.${f}"
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
  url="$1"
  path="$2"
  if [[ -d "$path" ]]; then
    if [[ -d "${path}/.git" ]]; then
      echo-cmd git -C "$path" pull
    elif ask "no .git found in ${path}, delete entire folder and clone repo?"; then
      rm -fr ${verbose:+-v} "$path"
    fi
  fi
  if [[ ! -d "$path" ]]; then
    mkdir -p ${verbose:+-v} "${path%/*}"
    echo-cmd git clone "$url" "$path"
  fi
}

finish() {
  echo 'done'
}

trap finish SIGHUP SIGINT SIGTERM

while true; do
  case "$1" in
    '-v'|'--verbose') verbose=true ;;
    *) break ;;
  esac
  shift
done

if ! has 'git' || ! has 'curl'; then
  err 'git and curl both required'
  exit 1
fi

backup_then_symlink profile bash_aliases bash_utils inputrc

if has git; then
  backup_then_symlink gitconfig
fi

if has vim; then
  backup_then_symlink vimrc
fi

if has zsh; then
  backup_then_symlink zshrc zprofile zlogin
  library https://github.com/robbyrussell/oh-my-zsh.git "${HOME}/.oh-my-zsh"
  library https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
  library https://github.com/tarruda/zsh-autosuggestions "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

if has tmux; then
  backup_then_symlink tmux.conf
  library https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
fi

if has node; then
  backup_then_symlink npmrc
fi

if has gem; then
  backup_then_symlink gemrc
fi

if has X; then
  if has startx; then
    backup_then_symlink xinitrc
  fi

  if has xmodmap; then
    backup_then_symlink xmodmap
    xmodmap "${HOME}/.xmodmap"
  fi

  if has xrdb; then
    backup_then_symlink Xresources
    xrdb -load "${HOME}/.Xresources"
  fi

  if [[ ! -f ~/.fonts/FantasqueSansMono-Regular.ttf  ]]; then
    [[ ! -f ${thisdir}/../downloads/fantasque-sans-mono.zip ]] && curl 'https://fontlibrary.org/assets/downloads/fantasque-sans-mono/db52617ba875d08cbd8e080ca3d9f756/fantasque-sans-mono.zip' -L -o "${thisdir}/../downloads/fantasque-sans-mono.zip"
    if [[ -f ${thisdir}/../downloads/fantasque-sans-mono.zip ]]; then
      unzip "${thisdir}/../downloads/fantasque-sans-mono.zip" '*.ttf' -d ~/.fonts
      mkfontdir "${HOME}/.fonts"
      xset +fp "${HOME}/.fonts"
      xset fp rehash
      fc-cache -f ${verbose:+-v}
    fi
  fi
else
  echo 'no X found'
fi

info 'done. you should probably log out'
