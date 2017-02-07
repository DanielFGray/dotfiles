#!/usr/bin/env zsh

autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -Uz colors && colors
autoload -Uz zmv

if [[ -f $HOME/.bash_aliases ]]; then
  source $HOME/.bash_aliases
else
 printf "${c_red}Error loading bash_aliases${c_reset}\n"
fi

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

VIRTUAL_ENV_DISABLE_PROMPT=1
DEFAULT_USER='dan'
plugins=(
  git-extras
  lein
  vi-mode
  zsh-autosuggestions
  zsh-syntax-highlighting
  autoenv
)
theme='agnoster'
[[ "$TTY" = '/dev/tty'* ]] && theme='kardan'

err() { printf "${colors[red]}%s${colors[reset]}\n" "$*"; }
die() { err "$@"; exit 1; }

source ~/.zsh/load.zsh || err 'error loading ~/.zsh/load.zsh'

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
if ! has nvm && [[ -f package.json && -s "/home/dan/.nvm/nvm.sh" ]]; then
  loadnvm
fi

if command -v fzf &> /dev/null; then
  [[ $(type historygrep) = *'alias'* ]] && unalias historygrep
  function historygrep {
    print -z $(fc -nl 1 | grep -v '^history' | fzf --tac +s -e -q "$*")
  }
fi

[[ $(type cd) = *'shell function'* ]] && unfunction cd
chpwd() {
  emulate -L zsh
  ls
  if ! has nvm && [[ -f package.json ]]; then
    loadnvm
  fi
}

unfunction ask
ask() {
  echo -n "$* "
  read -r -k 1 ans
  echo
  [[ ${ans:u} = Y* ]]
}

alias zcp='noglob zmv -C '
alias zln='noglob zmv -L '
alias zmv='noglob zmv '

alias -g L='| less'
alias -g S='| sort'
alias -g SU='| sort -u'
alias -g SUC='| sort | uniq -c | sort -n'
alias -g V='| vim -'
alias -g DN='&> /dev/null'

setopt append_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
setopt share_history

setopt extended_glob
setopt no_case_glob

setopt nomatch
setopt notify
setopt prompt_subst
setopt complete_in_word
setopt menu_complete

setopt autocd
setopt auto_pushd
setopt pushd_silent
setopt pushd_to_home
setopt pushd_minus
setopt pushd_ignore_dups

setopt no_flow_control

unsetopt beep

bindkey -v

bindkey '^ ' autosuggest-accept

bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[A' up-line-or-history
bindkey '\e[B' down-line-or-history

bindkey -M vicmd 'q' push-line
bindkey -M viins ' ' magic-space

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*' prompt '%e>'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion::*:(rm|vi):*' ignore-line true
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion::approximate*:*' prefix-needed false

export DISABLE_AUTO_TITLE=true

export PATH="$HOME/.yarn/bin:$PATH"
