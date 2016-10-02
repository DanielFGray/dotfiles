#!/usr/bin/env zsh

autoload -Uz compinit && compinit
autoload -Uz colors && colors
autoload -Uz zmv


[[ -f $HOME/.bash_aliases ]] && source $HOME/.bash_aliases

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

DEFAULT_USER='dan'
theme='agnoster'
plugin_path=( "$HOME/.zsh/plugins" )
[[ -d "$HOME/.oh-my-zsh/plugins" ]] && plugin_path+=( "$HOME/.oh-my-zsh/plugins" )
[[ -d "$HOME/.oh-my-zsh/custom/plugins" ]] && plugin_path+=( "$HOME/.oh-my-zsh/custom/plugins" )
plugins=(
  fancy-ctrl-z
  git-extras
  vi-mode
  zsh-autosuggestions
  zsh-syntax-highlighting
)

load_plugins() {
  local errors=() loaded_p p p_path p_paths
  for p in "${plugins[@]}"; do
    for p_path in "${plugin_path[@]}"; do
      p_paths=( "$p_path/$p/$p.zsh" "$p_path/$p/$p.plugin.zsh" )
      for f in "${p_paths[@]}"; do
        if [[ -f "$f" ]]; then
          source "$f" || errors+=( "$p failed to load" )
          loaded_p="$f"
          break 2
        fi
      done
    done
    if [[ -z "$loaded_p" ]]; then
      errors+=( "$p not found" )
    fi
  done
  if [[ -n "$errors" ]]; then
    printf '%sError loading plugins:' "${c_red}"
    printf '\n  %s' "$errors"
    printf '%s\n' "$c_reset"
  fi
}
load_plugins

load_theme() {
  if [[ -n "$theme" ]]; then
    theme_path="$HOME/.zsh/themes/$theme.zsh-theme"
    if [[ -e "$theme_path" ]]; then
      source "$HOME/.zsh/themes/$theme.zsh-theme" ||
        printf "${c_red}Error loading theme: %s${c_reset}\n" "$theme"
    else
      printf "${c_red}Error loading theme: %s not found${c_reset}\n" "$theme"
    fi
  fi

}
load_theme

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
# export NVM_DIR="/home/dan/.nvm"
# [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"  # This loads nvm

bindkey '^ ' autosuggest-accept

if command -v fzf &> /dev/null; then
  unalias historygrep
  function historygrep {
    print -z $(fc -nl 1 | grep -v '^history' | fzf --tac +s -e -q "$*")
  }
fi

unfunction cd
chpwd() {
  emulate -L zsh
  ls
}

unfunction ask
ask() {
  echo -n "$* "
  read -r -k 1 ans
  echo
  [[ ${ans:u} == Y* ]]
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
setopt extended_glob
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
unsetopt beep
bindkey -v

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*' prompt '%e>'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

compdef _pacman pacman-color=pacman
