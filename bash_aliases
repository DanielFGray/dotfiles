#!/usr/bin/env bash

export MANPAGER="bash -c \"col -b | vim -Nu NONE -c 'runtime macros/less.vim' -c 'setf man' -\""
export EDITOR='vim'
export HISTFILESIZE=500000
export HISTSIZE=100000
unset GREP_OPTIONS
stty -ixon

for bu in "${HOME}/.bash_utils" "${HOME}/dotfiles/bash_utils"; do
  if [[ -s "$bu" ]]; then
    . "$bu"
    break
  fi
done
[[ -s "$bu" ]] || {
  err() { tput setaf 1; printf '%s\n' "$@"; tput sgr0; }
  err 'cannot source bash_utils' 'probably gonna die now'
}
unset d

has fortune && fortune -ae

if h=$(select_from apt 'apt-get'); then
  alias canhaz="sudo $h install "
  alias updupg="sudo $h upgrade "
  pkgrm() { sudo apt-get purge "$@" && sudo apt-get autoremove ;}
  has fuser dpkg && alias unlock-dpkg="sudo fuser -vki /var/lib/dpkg/lock; sudo dpkg --configure -a"
elif h=$(select_from yay aurman trizen pacaur yaourt pacman); then
  [[ $h = pacman ]] && h="sudo pacman"
  alias canhaz="$h -S "
  updupg() {
    $h -Sy && if has pkgup; then
       pkgup
    else
      $h -Syu
    fi
  }
  has pkgrm || alias pkgrm='sudo pacman -Rsu '
elif [[ -f /etc/redhat-release ]]; then
  alias canhaz='sudo dnf install '
elif [[ -f /etc/gentoo-release ]]; then
  alias canhaz='sudo emerge -av '
fi

alias ..='cd ..'
alias ...='cd ../..'

alias se='sudo -sE $EDITOR '

alias cp='cp -v '
alias mv='mv -v '
alias rm='rm -v '
alias ln='ln -v '
alias vidir='vidir -v '
alias chown='chown -v '
alias chmod='chmod -v '
alias rename='rename -v '
alias ls='ls -Fh --color --group-directories-first '
alias l='ls -lgo '
alias lt='l -t '
alias lx='l -X '
alias la='l -A '
alias lax='la -X '
alias lat='la -t '
grep --version | grep -q 'gnu' && alias grep='grep --exclude-dir={.bzr,CVS,.git,.hg,.svn,node_modules,bower_components,jspm_packages} --color=auto -P '
alias historygrep='history | command grep -vF "history" | grep '
alias shuf1='shuf -n1'
vba() {
  fc -rnl | $EDITOR ~/dotfiles/bash_aliases - +'set nomod bufhidden buftype=nofile | sp | bn | wincmd _'
  exec "${SHELL##*/}"
}

has cdu && alias cdu='cdu -isdhD '
has rsync && alias rsync='rsync -v --progress --stats '
has lein rlwrap && alias lein='rlwrap lein '
has pkgsearch && alias pkgs='FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview-window=bottom:hidden" pkgsearch '

if has python || has python3; then
  if ! has pip && has pip3; then
    alias pip='pip3 '
  fi
  has pip && alias pipi='pip install --user --upgrade '
  has ptpython && alias ptpy='ptpython '

  py() {
    if has ptpython && [[ -z "$*" ]]; then
      ptpython
    else
      python "$@"
    fi
  }
fi

has npx && alias npx='npx --no-install '

# {{{ git aliases
if has git; then
  alias g='git '
  alias ga='git add '
  alias gap='git add -p '
  alias gb='git branch '
  alias gc='git commit -v '
  alias gcm='git commit -m '
  alias gco='git checkout '
  alias gd='git diff '
  alias gl='git pull '
  alias gm='git merge --no-ff '
  alias gp='git push '
  alias gst='git status --untracked-files=no '
  alias gstu='git status -u '
  gcl() {
    local dir repo
    if [[ -z "$1" ]]; then
      echo 'no arguments specified'
      return 1
    fi
    case "$1" in
      http*|https*|git*|ssh*) repo="$1" ;;
      *) repo="https://github.com/$1" ;;
    esac
    shift
    if [[ -n "$1" && "$1" != -* ]]; then
      dir="$1"
      shift
    else
      dir="${repo##*/}"
      dir="${dir/%.git}"
    fi
    git clone "$repo" "$@"
    [[ -d "$dir" ]] && cd "$dir"
  }
  gsb() {
    if [[ -z "$1" ]]; then
      err 'No branch name specified'
      return 1
    fi
    git stash
    git stash branch "$1"
  }
fi
# }}}

rgf() {
  rg -l "$*" | fzf --preview="rg '$*' {}"
}

multiple() {
  local l x y p c
  c=0 p=0 l=()
  while :; do
    case $1 in
      -p)
        [[ $2 = -* ]] && { echo '-p requires an argument'; return; }
        p="$2"; shift ;;
      --) shift; break ;;
      *) l+=("$1")
    esac
    shift
  done
  echo
  if (( p > 1 )); then
    for y in "${l[@]}"; do
      (( c++ >= p )) && wait -n
      echo "$* $y"
      ("$@" "$y" &)
    done
    wait
  else
    for y in "${l[@]}"; do
      echo "$* $y"
      ("$@" "$y" &)
    done
  fi
}

watchfile() {
  local f x
  f=()
  while :; do
    case $1 in
      -f) f+=("$2"); shift ;;
      --) shift; break ;;
    esac
    shift
  done
  fn() {
    local p
    "$@" &
    p=$!
    inotifywait -e modify,attrib,close_write,move,create,delete "${f[@]}"
    if pgrep "$p"; then
      kill "$p"
    fi
    fn "$@"
  }
  fn "$@"
}

cd() {
  local dir
  if [[ -z "$*" ]]; then
    builtin cd ~ && ls
  else
    dir="$1"
    shift
    builtin cd "$dir" && ls "$@"
  fi
}

delete_empty() {
  while [[ -n $(find . -empty) ]]; do
    find . -empty -delete
  done
}

mkd() {
  mkdir -vp "$*" && cd "$*"
}

trash() {
  for arg in "$@"; do
    [[ "$arg" = -* ]] && shift
  done
  mkdir -vp ~/.trash
  mv -vt ~/.trash "$@"
}

cat() {
  if [[ -t 1 ]]; then
    more "$@" | LESS=-~FEXR less
  else
    command cat "$@"
  fi
}

help() {
  bash -c "help $*"
}

bground() {
  ("$@" &> /dev/null &)
}

restart() {
  pkill -x "$1"
  bground "$@"
}

function in {
  local t
  t=( "$1" "$2" )
  shift 2
  at now + "${t[@]}" <<< "$*"
}

decide() {
  local args
  args=( "$@" )
  (( $# < 2 )) && args=( yes no )
  printf '%s\n' "${args[@]}" | shuf -n1
}

genwords() {
  local n=5
  [[ -n $1 ]] && { n=$1; shift; }
  shuf /usr/share/cracklib/cracklib-small |
    head -n "$n" |
    tr '\n' ' ' |
    sed -r "s/'(\w)\b/\1/g; s/\b(.)/\u\1/g; s/ //g"
}

genchars() {
  local n=16 r='[a-z0-9]'
  [[ -n $1 ]] && { n=$1; shift; }
  [[ -n $1 ]] && { r=$1; shift; }
  printf '%s\n' "$(grep -a -oP "$r" < /dev/urandom | tr -d '\n' | head -c "$n")"
}

ed() { command ed -p: "$@" ;} # https://sanctum.geek.nz/arabesque/actually-using-ed/

if has tmux; then
  txs() {
    local nested opts
    opts=( -d )
    for a in "$@"; do
      case $a in
        -N) nested=1 ; shift ;;
        -*)  opts+=( "$1" ) ; shift ;;
      esac
    done
    cmd="$*"
    if [[ -n "$nested" ]]; then
      cmd="TMUX='' tmux new \; source ~/dotfiles/tmux.alt.conf \; send-keys ' $cmd' C-m"
    fi
    tmux split-window "${opts[@]}" "$cmd"
  }

  has gitup && upglibs() {
    txs "gitup -F -p8 ~/.oh-my-zsh ~/.zsh/plugins ~/.vim/bundle ~/.emacs.d ~/.fzf ~/.tmux/plugins; bash -c 'read -r -p \"Done! Press any key to close.\" -n1'"
  }
fi

sprunge() { more -- "$@" | command curl -sF 'sprunge=<-' http://sprunge.us ;}

pgrep() { ps aux | command grep -iP "$*" | command grep -ivF grep ;}

has tar ssh && {
  if has pv; then
    tarpipe() { tar czf - "$2" | pv | ssh "$1" "tar xzvf - $3" ;}
    rtarpipe() { ssh $1 "tar czf - $2" | pv | tar xzvf - ;}
  else
    tarpipe() { tar czf - "$2" | ssh "$1" "tar xzvf - $3" ;}
    rtarpipe() { ssh $1 "tar czf - $2" | tar xzvf - ;}
  fi
}

textImage() {
  convert -background white -fill black -size 500x500 -gravity Center -font Droid-Sans-Regular caption:"$1" "$2" &&
  optipng "$2" &&
  qiv "$2"
}

burnusb() {
  sudo dd of="$1" bs=4M conv=sync status=progress && {
    sync &&
    ding 'burnusb' 'done'
  }
}

ports_running() {
  $(select_from 'ss' 'netstat') -tulpn | $(select_from 'less -S' 'fzf')
}

changeroot() {
  emulate -L bash
  sudo cp -L /etc/resolv.conf "$1"/etc/resolv.conf
  sudo mount -t proc proc "$1"/proc
  sudo mount -t sysfs sys "$1"/sys
  # sudo mount -o bind /dev "$1"/dev
  # sudo mount -t devpts pts "$1"/dev/pts/
  sudo chroot "$1"/ /bin/bash
  ask "unmount $1? " && (
    sudo umount -l "$1"
    sudo chroot /
  )
  emulate -L zsh
}

extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)   tar -xjf "$@"   ;;
      *.tar.gz)    tar -xzf "$@"   ;;
      *.tar)       tar -xf "$@"    ;;
      *.tbz2)      tar -xjf "$@"   ;;
      *.tgz)       tar -xzf "$@"   ;;
      *.bz2)       bunzip2 "$@"    ;;
      *.rar)       unrar x "$@"    ;;
      *.gz)        gunzip "$@"     ;;
      *.zip)       unzip "$@"      ;;
      *.Z)         uncompress "$@" ;;
      *.7z)        7z x "$@"       ;;
      *.xz)        xz -d "$@"      ;;
      *)           echo "'$1' cannot be extracted via >extract<" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

curltar() {
  local d
  d="${1%%*/}"
  mkdir -v "$d" || return 1
  cd "$d" || return 1
  case "$1" in
    *.tar.bz2)   command curl -L "$1" | tar xvjf - ;;
    *.tar.gz)    command curl -L "$1" | tar xvzf - ;;
    *.bz2)       command curl -L "$1" | bunzip2  - ;;
    *.tar)       command curl -L "$1" | tar xvf  - ;;
    *.tbz2)      command curl -L "$1" | tar xvjf - ;;
    *.tgz)       command curl -L "$1" | tar xvzf - ;;
    *)           command curl -LO "$1"
  esac
}

whitenoise() { aplay -c 2 -f S16_LE -r 44100 /dev/urandom ;}

weather() { command curl -s http://wttr.in/"${*:-galveston texas}" ;}

if has vipe; then
  if has xclip; then
    alias eclip='xclip -o | vipe | xclip -r'
  fi

  if has synclient; then
    synclient() {
      if command synclient -l &> /dev/null; then
        if (( $# > 0 )); then
          command synclient "$@"
        else
          command synclient $(command synclient | vipe | sed '1d;s/ //g')
        fi
      else
        command synclient
      fi
    }
  fi
fi

if has fzf; then
  umnt() {
    local device
    device=$(mount -l | awk '
      $5 !~ /gvfsd|debugfs|hugetlbfs|mqueue|tracefs|devpts|securityfs|pstore|sysfs|proc|autofs|cgroup|fusect|tmpfs/ {
        print $1, $3, $5, $6
      }' |
      column -t |
      fzf --inline-info --reverse --height=50% |
      awk '{print $2}')
    [[ -n "$device" ]] && sudo umount -l "$device"
  }

  has npm npmsearch && alias npms='npmsearch '
  has npm npmuninstall && alias npmun='npmuninstall '
fi

loadnvm() {
  if [[ -s "/home/dan/.nvm/nvm.sh" ]] && ! has nvm; then
    echo 'loading nvm...'
    export NVM_DIR="$HOME/.nvm"
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use
    nvmuse() {
      local version
      version=$(unalias curl; nvm ls | fzf --inline-info --ansi --height=10 --reverse | grep -oP '(system|(iojs-)?v\d+\.\d+\.\d+)')
      [[ -n $version ]] && nvm use "$version"
    }

    nvminstall() {
      local version
      version=$(unalias curl; nvm ls-remote | fzf --inline-info --ansi --tac | grep -oP '(system|(iojs-)?v\d+\.\d+\.\d+)')
      [[ -n $version ]] && nvm install "$version"
    }

    nvmuninstall() {
      local version
      version=$(unalias curl; nvm ls | fzf --inline-info --ansi | grep -oP '(system|(iojs-)?v\d+\.\d+\.\d+)')
      [[ -n $version ]] && nvm uninstall "$version"
    }
  fi
}

[[ -s ~/.perlbrew/etc/bashrc ]] && {
  source ~/.perlbrew/etc/bashrc
}

nodemon() {
  if ! has node; then
    err 'node not found'
    return
  fi
  if [[ ! -x ./node_modules/.bin/nodemon ]]; then
    err 'nodemon not in ./node_modules'
    return
  fi
  if [[ $1 = '-'* ]]; then
    node ./node_modules/.bin/nodemon "$@"
  else
    file="$1"
    [[ $file = *'.js'  ]] || file="${file}.js"
    node ./node_modules/.bin/nodemon -w "$file" -x "node $file"
  fi
}

if has rlwrap; then
  node() {
    local args magicFile
    magicFile='./custom_repl.js'
    if (( $# > 0 )); then
      command node "$@"
    else
      if ! type -p node &> /dev/null; then
        if has loadnvm; then
          loadnvm
        else
          err 'node or nvm not installed?'
          return
        fi
      fi
      args=("$@")
      [[ -r "$magicFile" ]] && args+=( -r "$magicFile" )
      NODE_NO_READLINE=1 rlwrap -m -H ~/.node_repl_history -pblue node "${args[@]}"
    fi
  }
  has guile && {
    guile() {
      if (( $# > 0 )); then
        command guile "$@"
      else
        rlwrap guile
      fi
    }
  }

  has clojure && {
     clojure() {
      if (( $# > 0 )); then
        command clojure "$@"
      else
        rlwrap clojure
      fi
    }
  }
fi

[[ -e /opt/closure/compiler.jar ]] && {
  closure() {
    java -jar /opt/closure/compiler.jar "$@"
  }
}

has VBoxManage && vm() {
  VBoxManage startvm "$1" --type headless || return
  echo 'starting ssh...'
  ssh "$1"
  VBoxManage controlvm "$1" poweroff
}

has api && {
  api() {
    local output
    res=$(command api "$@")
    if output=$(jq -C '.' <<< "$res"); then
      echo "$output"
    else
      echo "$res"
    fi
  }

  gitlab_get_repoid() {
    res=$(command api gitlab get projects | jq ".[] | select(.name == \"$1\") | .id")
  }

  gitlab_make_public() {
    local repo
    repo="${1/\//%2F}"
    res=$(command api gitlab put "projects/$repo" -d 'visibility=public&issues_enabled=true&wiki_enabled=true&public_jobs=true')
  }

  gitlab_build_list() {
    local repoid
    repo="${1/\//%2F}"
    res=$(command api gitlab get "projects/$repo/jobs")
    jq '.[] | select(.status == "running")' <<< "$res"
  }
}

has boil && boil() {
  loadperlbrew
  command boil "$@" && while getopts 'n:' x; do
    case "$x" in
      n) cd ~/build/"$OPTARG"
    esac
  done
}

make() {
  if [[ "$*" == 'me a sandwich'* ]]; then
    shift 3
    ./configure "$@" && command make -j $(( $(nproc) - 1))
  else
    command make "$@"
  fi
}

diffplugins() {
  local file
  if (( $# < 1 )); then
    err 'need a file or url'
    return 1
  fi
  if [[ $1 = http* ]]; then
    has -v curl || return
    file=$(command curl -s "$1")
  elif [[ -r $1 ]]; then
    file=$(< "$1")
  else
    err "$1 is not a readable file or url"
    return 1
  fi
  diff -u <(command grep -Po "Plug '[^']+'" ~/.vimrc | sort) \
    <(command grep -Po "Plug '[^']+'" <<< "$file" | sort) |
    awk -F \' '/^\+/{printf "%s/%s\n", "https://github.com", $2}'
}

has fv && books() {
  [[ -n $ZSH_VERSION ]] && emulate -L bash
  local cmd dirs
  cmd=$(select_from okular evince zathura)
  for a; do
    case "$a" in
      -c) if has -v "$a"; then cmd="$a"; else return 1; fi
    esac
  done
  cd ~/books &> /dev/null
  fv -sado -c "$cmd"
  cd - &> /dev/null
}

has fzf mpv && {
  videos() {
    local d findopts fzfopts
    d="$HOME/videos"
    findopts=()
    fzfopts=( --bind="enter:execute(mpv --fullscreen $d/{})")
    if [[ $1 = '-t' ]]; then
      findopts=( -printf '%T@ %P\n' )
      fzfopts=( --bind="enter:execute(mpv --fullscreen $d/{2..})" --with-nth='2..' --tac )
    fi
    command find "$d" \
      -regextype posix-extended \
      -iregex '.*\.(mp4|avi|mkv)' \
      -type f \
      "${findopts[@]}" |
      sort -h |
      sed "s|$d/||" |
      fzf -e +s --height=75% --reverse --multi \
      --bind='esc:abort' \
      "${fzfopts[@]}"
  }

  videos_random() {
    local d movies
    d="$HOME/videos"
    movies=$(command find "$d" -regextype posix-extended -iregex '.*\.(mp4|avi|mkv)' -type f | sort -h | sed "s|$d/||" | fzf -e +s -m --height=75% --reverse)
    mpv --fullscreen "$d/$(shuf -n1 <<< "$movies")"
  }
}

has ffmpeg && {
  tomp3() {
    ffmpeg -i "$1" -qscale:a 0 "${1/%.*/.mp3}"
  }
}

has n && alias n='sudo n '

# vim:ft=sh:
