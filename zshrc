#!/usr/bin/env zsh

autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -Uz colors && colors
autoload -Uz zmv

if [[ -f $HOME/.bash_aliases ]]; then
  source $HOME/.bash_aliases
else
  printf '%s%s%s\n' "$(tput setaf 1)" 'Error loading bash_aliases' "$(tput sgr0)"
fi

HISTFILE="$HOME/.zsh_history"
HISTSIZE=999999999
HISTFILESIZE=999999999
SAVEHIST=$HISTSIZE
REPORTTIME=1

# MODE_INDICATOR="%{$fg[red]%}%{$bg[red]%}  %{$reset_color%}"
VIRTUAL_ENV_DISABLE_PROMPT=1
DEFAULT_USER='dan'
plugins=(
  fancy-ctrl-z
  git-extras
  vi-mode
  zsh-autosuggestions
  fast-syntax-highlighting
  yarn
  zsh-autopair
)
theme='agnoster'
[[ "$TTY" = '/dev/tty'* ]] && theme='kardan'

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

source ~/.zsh/load.zsh || err 'error loading ~/.zsh/load.zsh'

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

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

alias -s pdf=zathura
alias -s epub=zathura

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

# export PATH="$HOME/.yarn/bin:$PATH"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=/home/dan/.local/bin/luna-studio:$PATH
