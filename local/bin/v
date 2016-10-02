#!/usr/bin/env bash

declare -r esc=$'\033'
declare -r c_reset="${esc}[0m"
declare -r c_red="${esc}[31m"
declare -r c_blue="${esc}[34m"
declare noselect
declare -a files
declare -a vimopts

usage() {
  LESS=-FEXR less <<'HELP'
v [OPTIONS] [FILES]
create a new vim server or interact with an existing one

    -d       disable focusing on vim
    + 'str'  return expr
    : 'str'  send command
    ! 'str'  send raw keys
HELP
}

in_term() {
  [[ -t 0 || -p /dev/stdin ]]
}

info() {
  if in_term; then
    printf "${c_blue}%s${c_reset}\n" "$*" >&2
  else
    zenity --info --text="$*"
  fi
}

err() {
  if in_term; then
    printf "${c_red}%s${c_reset}\n" "$*" >&2
  else
    zenity --error --text="$*"
  fi
}

die() {
  [[ -n "$1" ]] && err "$1"
  exit 1
}

has() {
  local verbose=false
  if [[ $1 == '-v' ]]; then
    verbose=true
    shift
  fi
  for c in "$@"; do c="${c%% *}"
    if ! command -v "$c" &> /dev/null; then
      [[ "$verbose" == true ]] && err "$c not found"
      return 1
    fi
  done
}

vim() {
  if has nvim nvr; then
    NVIM_LISTEN_ADDRESS="/tmp/nvimsocket" nvr -l "$@"
  else
    command vim "$@"
  fi
}

select_pane() {
  serv="$1"
  if [[ -n "$TMUX" && "$noselect" != true ]]; then
    pane=$(vim --servername "$serv" --remote-expr '$TMUX_PANE')
    if [[ -n "$pane" ]]; then
      tmux select-pane   -t "$pane"
      tmux select-window -t "$pane"
    fi
  fi &
}

start_server() {
  if in_term; then
    if [[ "$noselect" != true && -n "$TMUX" ]]; then
      tmux rename-window -t "$TMUX_PANE" 'vim'
      if ! tmux list-sessions -F '#S' | grep -qF 'cmd'; then
        if [[ -e "$HOME/.tmux.alt.conf" ]]; then
          tmux_opts='source-file $HOME/.tmux.alt.conf'
        else
          tmux_opts="set prefix C-s \; bind s send-prefix \; bind C-s last-window \; unbind C-a \; set status-position top \; set status-justify centre \; set status-right '' \; set status-left ''"
        fi
        tmux split-window -t "$TMUX_PANE" -d -v -p 25 "TMUX="" tmux new-session -s \"cmd\" \; $tmux_opts"
      fi
    fi &
    if has nvim nvr; then
      NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim "$@"
    else
      vim --servername 'VIMSERVER'  "$@"
    fi
  else
    has gvim || die 'cannot start new vim server'
    exec gvim --servername 'VIMSERVER'  "$@"
  fi
}

if ! has vim && ! has nvim; then
  die 'vim or nevim not found!'
fi

while true; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    -d) noselect=true; ;;
    *) break ;;
  esac
  shift
done

if has nvim nvr; then
    if [[ -e /tmp/nvimsocket ]]; then
      serv=/tmp/nvimsocket
    else
      serv=''
    fi
else
  serv=$(vim --serverlist | grep -oP -m1 '^VIMSERVER$')
fi

if [[ -n "$serv" ]]; then
  vimopts=( '--servername' "$serv" )
  if (( $# == 0 )); then
    has fv || die 'enter a file name'
    if in_term; then
      fv -c "v ${noselect:+-d}"
      exit 0
    else
      x-terminal-emulator -e fv -c v
    fi
  else
    while (( $# > 0 )); do
      case "$1" in
        :*) vim "${vimopts[@]}" --remote-send "<esc>$1<cr>" ;;
        !*) vim "${vimopts[@]}" --remote-send "${1:1}" ;;
        +*) vim "${vimopts[@]}" --remote-expr "${1:1}" ;;
        http://* | https://* ) vim "${vimopts[@]}" --remote-send "<esc>:enew | r !command curl -sL $1<cr><esc>ggdd:setfiletype " ;;
        *) files+=("$1") ;;
      esac
      shift
    done
  fi
  select_pane "$serv"
  for f in "${files[@]}"; do
    if [[ -d "$f" ]]; then
      f=$(ag -lk)
    fi
    vim "${vimopts[@]}" --remote "$f"
    sleep 0.2
  done
else
  start_server "$@"
fi
