# Updates editor information when the keymap changes.
function zle-keymap-select() {
  zle reset-prompt
  zle -R
}
zle -N zle-keymap-select

# Ensure that the prompt is redrawn when the terminal size changes.
TRAPWINCH() {
  zle && { zle reset-prompt; zle -R }
}

bindkey -v

# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history

# allow ctrl-h, ctrl-w, ctrl-? for char and word deletion (standard behaviour)
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

# if mode indicator wasn't setup by theme, define default
if [[ -z "$MODE_INDICATOR" ]]; then
  MODE_INDICATOR="%{$fg_bold[red]%}<%{$fg[red]%}<<%{$reset_color%}"
fi

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}

# define right prompt, if it wasn't defined by a theme
if [[ -z "$RPS1" && -z "$RPROMPT" ]]; then
  RPS1='$(vi_mode_prompt_info)'
fi

# change cursor style based on mode
function zle-keymap-select zle-line-init {
  case $KEYMAP in
    vicmd)      print -n -- "\E[1 q" ;;  # blinking block cursor
    viins|main) print -n -- "\E[5 q" ;;  # blinking line cursor
  esac
  zle reset-prompt
  zle -R
}

function zle-line-finish {
  print -n -- "\E[5 q"  # blinking line cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# add more vim-like operators

bindkey -M vicmd 'cc' vi-change-whole-line
bindkey -M vicmd 'dd' kill-whole-line

_vi_delete-in() {
  local char lchar rchar lsearch rsearch count
  read -k char
  if [[ "$char" = 'w' ]]; then
    zle vi-backward-word
    lsearch="$CURSOR"
    zle vi-forward-word
    rsearch="$CURSOR"
    RBUFFER="$BUFFER[$rsearch+1,${#BUFFER}]"
    LBUFFER="$LBUFFER[1,$lsearch]"
    return
  elif [[ "$char" = '(' || "$char" = ')' ]]; then
    lchar='('
    rchar=')'
  elif [[ "$char" = '[' || "$char" = ']' ]]; then
    lchar='['
    rchar=']'
  elif [[ "$char" = '{' || "$char" = '}' ]]; then
    lchar='{'
    rchar='}'
  else
    lsearch="${#LBUFFER}"
    while (( lsearch > 0 )) && [[ "$LBUFFER[$lsearch]" != "$char" ]]; do
      (( lsearch-- ))
    done
    rsearch=0
    while [[ $rsearch -lt (( ${#RBUFFER} + 1 )) ]] && [[ "$RBUFFER[$rsearch]" != "$char" ]]; do
      (( rsearch++ ))
    done
    RBUFFER="$RBUFFER[$rsearch,${#RBUFFER}]"
    LBUFFER="$LBUFFER[1,$lsearch]"
    return
  fi
  count=1
  lsearch="${#LBUFFER}"
  while (( lsearch > 0 )) && (( count > 0 )); do
    (( lsearch-- ))
    if [[ "$LBUFFER[$lsearch]" = "$rchar" ]]; then
      (( count++ ))
    fi
    if [[ "$LBUFFER[$lsearch]" = "$lchar" ]]; then
      (( count-- ))
    fi
  done
  count=1
  rsearch=0
  while (( "$rsearch" < ${#RBUFFER} + 1 )) && [[ "$count" > 0 ]]; do
    (( rsearch++ ))
    if [[ $RBUFFER[$rsearch] = "$lchar" ]]; then
      (( count++ ))
    fi
    if [[ $RBUFFER[$rsearch] = "$rchar" ]]; then
      (( count-- ))
    fi
  done
  RBUFFER="$RBUFFER[$rsearch,${#RBUFFER}]"
  LBUFFER="$LBUFFER[1,$lsearch]"
}
zle -N _vi_delete-in
bindkey -M vicmd 'di' _vi_delete-in

_vi_delete-around() {
  zle _vi_delete-in
  zle vi-backward-char
  zle vi-delete-char
  zle vi-delete-char
}
zle -N _vi_delete-around
bindkey -M vicmd 'da' _vi_delete-around

_vi_change-in() {
  zle _vi_delete-in
  zle vi-insert
}
zle -N _vi_change-in
bindkey -M vicmd 'ci' _vi_change-in

_vi_change-around() {
  zle _vi_delete-in
  zle vi-backward-char
  zle vi-delete-char
  zle vi-delete-char
  zle vi-insert
}
zle -N _vi_change-around
bindkey -M vicmd 'ca' _vi_change-around
