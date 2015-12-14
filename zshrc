ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
COMPLETION_WAITING_DOTS="true"
DEFAULT_USER="dan"
plugins=( vi-mode git git-extras zsh-syntax-highlighting )
source $ZSH/oh-my-zsh.sh

[[ -f $HOME/.bash_aliases ]] && source $HOME/.bash_aliases
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

if command -v fzf &> /dev/null; then
  unalias historygrep
  function historygrep {
    print -z $(fc -nl 1 | grep -v '^history' | fzf --tac +s -e -q "$*")
  }
fi

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

unfunction cd
chpwd() {
  emulate -L zsh
  ls
}

autoload -U zmv

alias zcp='noglob zmv -C '
alias zln='noglob zmv -L '
alias zmv='noglob zmv '

alias -g L='| less'
alias -g S='| sort'
alias -g SU='| sort | uniq | sort'
alias -g SUC='| sort | uniq -c | sort -n'
alias -g V='| vim -'
alias -g DN='&> /dev/null'

bindkey -v
bindkey '^[[A'  history-search-backward
bindkey '^[[B'  history-search-forward
bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history
bindkey '^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

bindkey -M vicmd 'cc' vi-change-whole-line
bindkey -M vicmd 'dd' kill-whole-line
# bindkey -M vicmd 'Y' y$

delete-in() {
  local CHAR LCHAR RCHAR LSEARCH RSEARCH COUNT
  read -k CHAR
  if [[ "$CHAR" == 'w' ]];then
    zle vi-backward-word
    LSEARCH="$CURSOR"
    zle vi-forward-word
    RSEARCH="$CURSOR"
    RBUFFER="$BUFFER[$RSEARCH+1,${#BUFFER}]"
    LBUFFER="$LBUFFER[1,$LSEARCH]"
    return
  elif [[ "$CHAR" == '(' || "$CHAR" == ')' ]];then
    LCHAR='('
    RCHAR=')'
  elif [[ "$CHAR" == '[' || "$CHAR" == ']' ]];then
    LCHAR='['
    RCHAR=']'
  elif [[ "$CHAR" == '{' || "$CHAR" == '}' ]];then
    LCHAR='{'
    RCHAR='}'
  else
    LSEARCH="${#LBUFFER}"
    while (( LSEARCH > 0 )) && [[ "$LBUFFER[$LSEARCH]" != "$CHAR" ]]; do
      (( LSEARCH-- ))
    done
    RSEARCH=0
    while [[ $RSEARCH -lt (( ${#RBUFFER} + 1 )) ]] && [[ "$RBUFFER[$RSEARCH]" != "$CHAR" ]]; do
      (( RSEARCH++ ))
    done
    RBUFFER="$RBUFFER[$RSEARCH,${#RBUFFER}]"
    LBUFFER="$LBUFFER[1,$LSEARCH]"
    return
  fi
  COUNT=1
  LSEARCH="${#LBUFFER}"
  while (( LSEARCH > 0 )) && (( COUNT > 0 )); do
    (( LSEARCH-- ))
    if [[ "$LBUFFER[$LSEARCH]" == "$RCHAR" ]];then
      (( COUNT++ ))
    fi
    if [[ "$LBUFFER[$LSEARCH]" == "$LCHAR" ]];then
      (( COUNT-- ))
    fi
  done
  COUNT=1
  RSEARCH=0
  while (( "$RSEARCH" < ${#RBUFFER} + 1 )) && [[ "$COUNT" > 0 ]]; do
    (( RSEARCH++ ))
    if [[ $RBUFFER[$RSEARCH] == "$LCHAR" ]];then
      (( COUNT++ ))
    fi
    if [[ $RBUFFER[$RSEARCH] == "$RCHAR" ]];then
      (( COUNT-- ))
    fi
  done
  RBUFFER="$RBUFFER[$RSEARCH,${#RBUFFER}]"
  LBUFFER="$LBUFFER[1,$LSEARCH]"
}
zle -N delete-in
bindkey -M vicmd 'di' delete-in

delete-around() {
  zle delete-in
  zle vi-backward-char
  zle vi-delete-char
  zle vi-delete-char
}
zle -N delete-around
bindkey -M vicmd 'da' delete-around

change-in() {
  zle delete-in
  zle vi-insert
}
zle -N change-in
bindkey -M vicmd 'ci' change-in

change-around() {
  zle delete-in
  zle vi-backward-char
  zle vi-delete-char
  zle vi-delete-char
  zle vi-insert
}
zle -N change-around
bindkey -M vicmd 'ca' change-around

