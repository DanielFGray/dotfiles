#!/usr/bin/env zsh

autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -Uz colors && colors
autoload -Uz zmv

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

if [[ -f $HOME/.bash_aliases ]]; then
  source $HOME/.bash_aliases
else
  print "$fg[red]Error loading bash_aliases$reset_color\n"
fi

HISTFILE="$HOME/.zsh_history"
HISTSIZE=999999999
HISTFILESIZE=999999999
SAVEHIST=$HISTSIZE
REPORTTIME=1

MODE_INDICATOR="%{$fg[red]%}%{$bg[red]%}  %{$reset_color%}"
VIRTUAL_ENV_DISABLE_PROMPT=1
DEFAULT_USER='dan'
plugins=(
  fancy-ctrl-z
  git-extras
  vi-mode
  zsh-autosuggestions
  fast-syntax-highlighting
  zsh-autopair
  you-should-use
)
has docker docker-compose && plugins+=( docker-compose )
has yarn && plugins+=( yarn )

theme='agnoster'
[[ "$TTY" = '/dev/tty'* ]] && theme='kardan'
ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd
ZSH_AUTOSUGGEST_USE_ASYNC=1

# ZPLUG_REPOS=~/.zsh/plugins
# source ~/.zsh/zplug/init.zsh
# zplug "zsh-users/zsh-autosuggestions", defer:2
# zplug "zdharma/fast-syntax-highlight", defer:2
# zplug "themes:agnoster", as:theme, from:oh-my-zsh
# zplug "~/.zsh/plugins", from:local
# # if ! zplug check --verbose; then
# #     printf "Install? [y/N]: "
# #     if read -q; then
# #         echo; zplug install
# #     fi
# # fi
# zplug load

export YSU_HARDCORE=1

source ~/.zsh/load.zsh || err 'error loading ~/.zsh/load.zsh'

[[ -f package.json ]] && loadnvm

if command -v fzf &> /dev/null; then
  [[ $(type historygrep) = *'alias'* ]] && unalias historygrep
  function historygrep {
    print -z $(fc -nl 1 | grep -v '^history' | fzf --reverse --tac +s -e --height=20% -q "$*")
  }
fi

[[ $(type cd) = *'shell function'* ]] && unfunction cd
chpwd() {
  emulate -L zsh
  ls
  [[ -f package.json ]] && loadnvm
}

[[ $(type cd) = *'shell function'* ]] && unfunction ask
ask() {
  echo -n "$* "
  read -r -k 1 ans
  echo
  [[ ${ans:u} = Y* ]]
}

if has fzf; then
  has fzrepl && fzrepl() {
    local x
    x=$(command fzrepl "$@")
    if $?; then
      print -z "$x"
    else
      print $x
    fi
  }
fi

alias zcp='noglob zmv -C '
alias zln='noglob zmv -L '
alias zmv='noglob zmv '

alias -g L='| less -R'
alias -g S='| sort'
alias -g SU='| sort -u'
alias -g SUC='| sort | uniq -c | sort -n'
alias -g V='| vim -'
alias -g DN='&> /dev/null'
alias -g F='| fzf -e -m'

has jq && {
  alias -s json='jq -C "."'
}

has x-pdf && {
  alias -s pdf=x-pdf
  alias -s epub=x-pdf
}

setopt append_history
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
setopt interactivecomments

unsetopt beep

bindkey -v

bindkey '^ ' autosuggest-accept

bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[A' up-line-or-history
bindkey '\e[B' down-line-or-history
bindkey ' ' magic-space

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
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

export DISABLE_AUTO_TITLE=true

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
