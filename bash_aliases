#!/usr/bin/env bash

for bu in "${HOME}/.bash_utils" "${HOME}/dotfiles/bash_utils"; do
  if [[ -s "$bu" ]]; then
    . "$bu"
    break
  fi
done
[[ -s "$bu" ]] || {
  err() {
    tput setaf 1
    printf '%s\n' "$@"
    tput sgr0
  }
  err 'cannot source bash_utils' 'probably gonna die now'
}
unset d

export EDITOR=$(select_from 'nvim' 'vim' 'vi')
if has nvim; then
  export MANPAGER='nvim +Man!'
else
  export MANPAGER="bash -c \"col -b | vim -Nu NONE -c 'runtime macros/less.vim' -c 'setf man' -\""
fi

export HISTFILESIZE=500000
export HISTSIZE=100000
unset GREP_OPTIONS
# stty -ixon

if h=$(select_from apt 'apt-get'); then
  alias canhaz="sudo $h install "
  alias updupg="sudo $h upgrade "
  pkgrm() { sudo apt-get purge "$@" && sudo apt-get autoremove; }
  has fuser dpkg && alias unlock-dpkg="sudo fuser -vki /var/lib/dpkg/lock; sudo dpkg --configure -a"
  unset h
elif AURHELPER=$(select_from yay aurman trizen pacaur yaourt pacman); then
  [[ $AURHELPER = pacman ]] && AURHELPER="sudo pacman"
  alias canhaz='$AURHELPER -S '
  updupg() {
    $AURHELPER -Sy && if has pkgup; then
      pkgup
    else
      $AURHELPER -Syu
    fi
  }
  has pkgrm || alias pkgrm='sudo pacman -Rsu '
elif [[ -f /etc/redhat-release ]]; then
  alias canhaz='sudo dnf install '
elif [[ -f /etc/gentoo-release ]]; then
  alias canhaz='sudo emerge -av '
fi

# alias ..='builtin cd ..'
# alias ...='builtin cd ../..'
# alias ....='builtin cd ../../..'

alias se='sudo -sE $EDITOR '

alias cp='cp -v '
alias mv='mv -v '
alias rm='rm -vI '
alias ln='ln -v '
alias vidir='vidir -v '
alias chown='chown -v '
alias chmod='chmod -v '
alias rename='rename -v '

if has lsd; then
  alias ls='lsd -Fh --color=always --date=relative '
  alias l='lsd --group-dirs first --date=relative '
  alias lx='l -X '
else
  alias ls='ls -Fh --color'
  alias l='ls --group-directories-first '
  alias lx='l -x '
fi
alias lt='ls -tr '
alias ll='l -l '
alias llx='lx -l '
alias llt='lt -l '
alias la='l -A '
alias lxa='lx -A '
alias lta='lt -A '
alias lla='ll -A '
alias llxa='llx -A '
alias llta='llt -A '

if grep --version | grep -q 'gnu'; then
  grep() {
    local exclude_file has_engine opts
    opts=()
    for a; do
      case $a in
      -G) has_engine=-G ;;
      -F) has_engine=-F ;;
      -E) has_engine=-E ;;
      *) opts+=("$a") ;;
      esac
    done
    if [[ -r .gitignore ]]; then
      exclude_file=.gitignore
    fi
    command grep --color=auto ${exclude_file:+--exclude-from=$exclude_file} ${has_engine:+$has_engine} "${opts[@]}"
  }
fi
alias shuf1='shuf -n1'
vba() {
  fc -rnl | $EDITOR - ~/dotfiles/bash_aliases ~/dotfiles/zshrc +'set nomod nobuflisted bufhidden bufhidden=wipe buftype=nofile | sp | bn | wincmd _'
  exec "${SHELL##*/}"
}

alias historygrep='history | command grep -vF "history" | grep '
historystats() {
  fc -l 1 | awk '{ CMD[$2]++; count++ } END { for (a in CMD) print CMD[a] " " CMD[a]/count*100 "% " a }' | column -c3 -s ' ' -t | sort -nr | nl -w2 | head -n25
}

has cdu && alias cdu='cdu -isdhD '
has rsync && alias rsync='rsync -v --progress --stats '
has lein rlwrap && alias lein='rlwrap lein '
has pkgsearch && alias pkgs='FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview-window=bottom:hidden" pkgsearch '

if has bun; then
  alias b='bun '
  alias bx='bunx '
fi

if has ni && [[ $(ni --version) = '@antfu'* ]]; then
  alias nid='ni -d '
  alias nst='nr start'
  alias nd='nr dev'
  alias nb='nr build'
  alias nt='nr test'
  # alias nun='nun' # uninstall
fi

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

opencode() {
  bun -g --silent i opencode-ai@latest
  command opencode "$@"
}

# {{{ git aliases
if has git; then
  alias g='git '
  alias ga='fzgit add '
  alias gap='g add -p '
  alias gb='g branch '
  alias gc='g commit -v '
  alias gcm='g commit -m '
  alias gco='fzgit checkout '
  alias gd='fzgit diff '
  alias gl='g pull '
  alias gr='g rebase '
  alias gri='fzgit rebase '
  alias gp='g push '
  alias gst='fzgit status '
  alias glo='fzgit log '

  gcl() {
    local dir repo
    if [[ -z "$1" ]]; then
      echo 'no arguments specified'
      return 1
    fi
    case "$1" in
    http* | https* | git* | ssh*) repo="$1" ;;
    *) repo="https://github.com/$1" ;;
    esac
    shift
    if [[ -n "$1" && "$1" != -* ]]; then
      dir="$1"
      shift
    else
      dir="${repo##*/}"
      dir="${dir/%.git/}"
    fi
    git clone "$repo" "$@"
    [[ -d "$dir" ]] && cd "$dir"
    [[ -e package.json ]] && yarn
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
  local l x y p c v
  c=0 p=0 l=()
  if (($# < 2)); then
    err 'missing args'
    return
  fi
  while :; do
    case $1 in
    -v) v=1 ;;
    -p)
      if [[ $2 = -* ]]; then
        echo '-p requires an argument'
        return
      fi
      p="$2"
      shift
      ;;
    --)
      shift
      break
      ;;
    *) l+=("$1") ;;
    esac
    shift
  done
  echo
  if ((p > 1)); then
    for y in "${l[@]}"; do
      ((c++ >= p)) && wait -n
      echo "$* $y"
      ("$@" "$y" &)
    done
    wait
  else
    for y in "${l[@]}"; do
      [[ -n $v ]] && echo "$* $y"
      ("$@" "$y" &)
    done
  fi
}

has inotifywait && watchfile() {
  local f x
  f=()
  while :; do
    case $1 in
    -f)
      f+=("$2")
      shift
      ;;
    --)
      shift
      break
      ;;
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
  if (($# > 0)); then
    builtin cd "$1" && \ls -trF --color
  else
    builtin cd ~ && \ls -trF --color
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
  ("$@" &>/dev/null &)
}

restart() {
  pkill -x "$1"
  bground "$@"
}

cmd_stats() {
  fc -l 1 |
    awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' |
    grep -v "./" |
    column -c3 -s " " -t |
    sort -nr |
    nl |
    head -n25
}

function in {
  local t
  t=("$1" "$2")
  shift 2
  at now + "${t[@]}" <<<"$*"
}

decide() {
  local args
  args=("$@")
  (($# < 2)) && args=(yes no)
  printf '%s\n' "${args[@]}" | shuf -n1
}

alias genwords='passgen -w '

genchars() {
  local n=16 r='[a-z0-9]'
  [[ -n $1 ]] && {
    n=$1
    shift
  }
  [[ -n $1 ]] && {
    r=$1
    shift
  }
  printf '%s\n' "$(grep -a -oP "$r" </dev/urandom | tr -d '\n' | head -c "$n")"
}

ed() { # https://sanctum.geek.nz/arabesque/actually-using-ed/
  command ed -p'> ' "$@"
}

if has tmux; then
  alias tmuxa='tmux attach'
  txs() {
    local nested opts
    opts=(-d)
    for a in "$@"; do
      case $a in
      -N)
        nested=1
        shift
        ;;
      -*)
        opts+=("$1")
        shift
        ;;
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

sprunge() { more -- "$@" | command curl -sF 'sprunge=<-' http://sprunge.us; }

if has tar ssh; then
  if has pv; then
    tarpipe() { tar czf - "$2" | pv | ssh "$1" "tar xzvf - $3"; }
    rtarpipe() { ssh $1 "tar czf - $2" | pv | tar xzvf -; }
  else
    tarpipe() { tar czf - "$2" | ssh "$1" "tar xzvf - $3"; }
    rtarpipe() { ssh $1 "tar czf - $2" | tar xzvf -; }
  fi
fi

text_image() {
  local file="$2"
  if [[ -z "$file" ]]; then file="$(date +%FTZ%TZ).png"; fi
  magick -background white -fill black -size 500x500 -gravity Center -font Droid-Sans-Regular caption:"$1" "$file"
  [[ -f "$file" ]] || return 1
  has optipng && optipng "$file"
  $(select_from gwenview mirage sxiv qiv) "$file"
}

burnusb() {
  sudo dd if="$1" of="$2" bs=4M conv=sync status=progress && {
    sync &&
      ding 'burnusb' 'done'
  }
}

ports_running() {
  $(select_from 'ss' 'netstat') -tulpn | $(select_from 'fzf' 'less -S')
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
    *.tar.bz2) tar -xjf "$@" ;;
    *.tar.gz) tar -xzf "$@" ;;
    *.tar) tar -xf "$@" ;;
    *.tbz2) tar -xjf "$@" ;;
    *.tgz) tar -xzf "$@" ;;
    *.bz2) bunzip2 "$@" ;;
    *.rar) unrar x "$@" ;;
    *.gz) gunzip "$@" ;;
    *.zip) unzip "$@" ;;
    *.Z) uncompress "$@" ;;
    *.7z) 7z x "$@" ;;
    *.xz) xz -d "$@" ;;
    *) echo "'$1' cannot be extracted via >extract<" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

curltar() {
  local d
  d="${1##*/}"
  mkdir -vp "$d" || return 1
  cd "$d" || return 1
  case "$1" in
  *.tar.bz2) command curl -L "$1" | tar xvjf - ;;
  *.tar.gz) command curl -L "$1" | tar xvzf - ;;
  *.bz2) command curl -L "$1" | bunzip2 - ;;
  *.tar) command curl -L "$1" | tar xvf - ;;
  *.tbz2) command curl -L "$1" | tar xvjf - ;;
  *.tgz) command curl -L "$1" | tar xvzf - ;;
  *) command curl -LO "$1" ;;
  esac
}

whitenoise() { aplay -c 2 -f S16_LE -r 44100 /dev/urandom; }

weather() {
  command curl https://wttr.in/"${*:-galveston%20texas}"
}

has asciinema && asciinema() {
  YSU_HARDCORE= command asciinema "$@"
}

has nr jq fzf && run-p() {
  [[ -e package.json ]] || {
    err 'no package.json!'
    return 1
  }
  if [[ ! -x ./node_modules/.bin/run-p ]]; then
    err 'no run-p?'
    return 1
  fi
  nr run-p $(jq -r '.scripts | keys[]' package.json F -m)
}

if has vipe; then
  if has xclip; then
    alias eclip='xclip -o | vipe | xclip -r'
  fi

  if has synclient; then
    synclient() {
      if command synclient -l &>/dev/null; then
        if (($# > 0)); then
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
      version=$(
        unalias curl
        nvm ls | fzf --inline-info --ansi --height=10 --reverse | grep -oP '(system|(iojs-)?v\d+\.\d+\.\d+)'
      )
      [[ -n $version ]] && nvm use "$version"
    }

    nvminstall() {
      local version
      version=$(
        unalias curl
        nvm ls-remote | fzf --inline-info --ansi --tac | grep -oP '(system|(iojs-)?v\d+\.\d+\.\d+)'
      )
      [[ -n $version ]] && nvm install "$version"
    }

    nvmuninstall() {
      local version
      version=$(
        unalias curl
        nvm ls | fzf --inline-info --ansi | grep -oP '(system|(iojs-)?v\d+\.\d+\.\d+)'
      )
      [[ -n $version ]] && nvm uninstall "$version"
    }
  fi
}

[[ -s ~/.perlbrew/etc/bashrc ]] && {
  source ~/.perlbrew/etc/bashrc
}

if has rlwrap; then
  node() {
    local args magicFile
    magicFile='./custom_repl.js'
    args=("$@")
    [[ $# = 0 && -r "$magicFile" ]] && args+=(-r "$magicFile")
    command node "${args[@]}"
  }

  has guile && {
    guile() {
      if (($# > 0)); then
        command guile "$@"
      else
        rlwrap guile
      fi
    }
  }

  has clojure && {
    clojure() {
      if (($# > 0)); then
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
    if output=$(jq -C '.' <<<"$res"); then
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
    jq '.[] | select(.status == "running")' <<<"$res"
  }
}

has boil && boil() {
  loadperlbrew
  command boil "$@" && while getopts 'n:' x; do
    case "$x" in
    n) cd ~/build/"$OPTARG" ;;
    esac
  done
}

make() {
  if [[ "$*" == 'me a sandwich'* ]]; then
    shift 3
    ./configure "$@" && command make -j $(($(nproc) - 1))
  else
    command make "$@"
  fi
}

diffplugins() {
  local file
  if (($# < 1)); then
    err 'need a file or url'
    return 1
  fi
  if [[ $1 = http* ]]; then
    has -v curl || return
    file=$(command curl -s "$1")
  elif [[ -r $1 ]]; then
    file=$(<"$1")
  else
    err "$1 is not a readable file or url"
    return 1
  fi
  diff -u <(command grep -Po "Plug '[^']+'" ~/.vimrc | sort) \
    <(command grep -Po "Plug '[^']+'" <<<"$file" | sort) |
    awk -F \' '/^\+/{printf "%s/%s\n", "https://github.com", $2}'
}

has fv && books() {
  [[ -n $ZSH_VERSION ]] && emulate -L bash
  local cmd dirs
  cmd=$(select_from okular evince zathura)
  for a; do
    case "$a" in
    -c) if has -v "$a"; then cmd="$a"; else return 1; fi ;;
    esac
  done
  cd ~/books &>/dev/null
  fd . ~/books -t f --color always | fzf --preview='pdftotext {} -' --bind="enter:execute:$cmd {}"
  cd - &>/dev/null
}

has fzf mpv && {
  videos() {
    local d findopts fzfopts
    d="$HOME/videos"
    findopts=()
    fzfopts=("--bind=enter:execute(mpv --fullscreen $d/{})")
    if [[ $1 = '-t' ]]; then
      findopts=(-printf '%T@ %P\n')
      fzfopts=("--bind=enter:execute(mpv --fullscreen $d/{2..})" '--with-nth=2..' --tac)
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
    mpv --fullscreen "$d/$(shuf -n1 <<<"$movies")"
  }
}

has ffmpeg && {
  tomp3() {
    ffmpeg -i "$1" -qscale:a 0 "${1/%.*/.mp3}"
  }
}

has n && alias n='sudo n '

if has docker; then
  alias pgcli='docker run -it --rm --name pgcli -v ~/.config/pgcli:/root/.config/pgcli -v /var/run/postgresql:/var/run/postgresql kubetools/pgcli'
  dtbr() {
    local name="${PWD##*/}"
    docker build -t "$name:latest" . && docker run --rm -it --name "$name" "$name:latest"
  }

  has fzf && fzds() {
    local pkg
    pkg=$(
      docker search --limit=100 "$*" |
        fzf --height=10 --header-lines=1 --reverse --preview='docker inspect {1}'
    )
    if [[ -n $pkg ]]; then
      if [[ -n $ZSH_VERSION ]]; then
        print -z "docker pull ${pkg%% *}"
      elif ask "docker pull ${pkg%% *}?"; then
        docker pull "${pkg%% *}"
      fi
    fi
  }

  if has docker-compose; then
    dcp() {
      local f c
      [[ -z $1 ]] && {
        err "missing project directory"
        return
      }
      f=~/build/dockerfiles/"$1"/docker-compose.yml
      [[ ! -f $f ]] && {
        err ~/"build/dockerfiles/$1/docker-compose.yml does not exist"
        return
      }
      shift
      [[ -z $1 ]] && {
        err "missing command"
        return
      }
      case "$1" in
      up)
        shift
        [[ $1 = "-d" ]] && shift
        docker-compose -f "$f" up -d "$@"
        docker-compose -f "$f" logs -f "$@"
        return
        ;;
      *)
        docker-compose -f "$f" "$@"
        return
        ;;
      esac
    }
  fi
fi

img() {
  local file url=$1
  local overwrite=0
  if [[ $1 = '-F' ]]; then
    overwrite=1
    shift
  fi
  cd /tmp >/dev/null
  file="${url##*/}"
  if [[ -e $file && $overwrite = 0 ]]; then
    printf '%s exists, overwrite? [N/y] ' "$file"
    read -k1
    [[ $REPLY = 'y' ]] && overwrite=1
  fi
  if [[ ! -e $file || $overwrite = 1 ]]; then
    curl -L "$url" >"$file"
  fi
  if [[ ! -e "$file" ]]; then
    echo 'failed to download'
    return
  fi
  file "$file"
  mpv --loop=inf "$file"
  cd - >/dev/null
}

alias pgrep='fztop'

# vim:ft=sh:
