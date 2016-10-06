#!/usr/bin/env zsh

autoload -Uz compinit && compinit
autoload -Uz colors && colors
autoload -Uz zmv


[[ -f $HOME/.bash_aliases ]] && source $HOME/.bash_aliases

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

DEFAULT_USER='dan'
theme="${TTY_THEME:-agnoster}"
plugins=(
  fancy-ctrl-z
  git-extras
  vi-mode
  zsh-autosuggestions
  zsh-syntax-highlighting
)

load_plugins() {
  local plugin_path=( "$HOME/.zsh/plugins" ) errors=() loaded_p p p_path p_paths
  [[ -d "$HOME/.oh-my-zsh/plugins" ]] && plugin_path+=( "$HOME/.oh-my-zsh/plugins" )
  [[ -d "$HOME/.oh-my-zsh/custom/plugins" ]] && plugin_path+=( "$HOME/.oh-my-zsh/custom/plugins" )
  for p in "${plugins[@]}"; do
    for p_path in "${plugin_path[@]}"; do
      p_paths=( "$p_path/$p/$p.zsh" "$p_path/$p/$p.plugin.zsh" )
      for f in "${p_paths[@]}"; do
        if [[ -f "$f" ]]; then
          source "$f" || errors+=( "$p failed to load" )
          loaded_p="$p"
          break 2
        fi
      done
    done
    if [[ "$loaded_p" != "$p" ]]; then
      errors+=( "$p not found" )
    fi
  done
  if [[ -n "$errors" ]]; then
    printf '%sError loading plugins:' "${c_red}"
    printf '\n  %s' "${errors[@]}"
    printf '%s\n' "$c_reset"
  fi
  unset plugins
}
(( ${#plugins[@]} > 0 )) && load_plugins

load_theme() {
  local theme_path=( "$HOME/.zsh/themes" ) errors=() t file found_theme
  [[ -d "$HOME/.oh-my-zsh/themes" ]] && plugin_path+=( "$HOME/.oh-my-zsh/themes" )
  for t in "${theme_path[@]}"; do
    file="${t}/${theme}.zsh-theme"
    if [[ -f "$file" ]]; then
      source "$file" || errors+=( "$theme failed to load" )
      found_theme="$file"
      break
    fi
  done
  if [[ -z "$found_theme" ]]; then
    errors+=( "$theme not found" )
  fi
  if [[ -n "$errors" ]]; then
    printf '%sError loading theme:' "${c_red}"
    printf '\n  %s' "${errors[@]}"
    printf '%s\n' "$c_reset"
  fi
  unset theme
}
[[ -n "$theme" ]] && load_theme

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
