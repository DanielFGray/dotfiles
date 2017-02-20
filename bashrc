#!/usr/bin/env bash
case $- in
    *i*) ;;
      *) return;;
esac

[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases

HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth
shopt -s histappend
shopt -s histverify
shopt -s checkwinsize
shopt -s globstar
shopt -s extglob

_git_dirty() {
  local status
  status=$(command git status --porcelain  --untracked-files=no 2> /dev/null | tail -n1)
  [[ -n "$status" ]] && printf '*'
}

_git_head_status() {
  local gitdir
  gitdir="$(command git rev-parse --git-dir 2> /dev/null)"
  if [[ -f "${gitdir}/MERGE_HEAD" ]]; then
    printf '>M<'
  elif [[ -d "${gitdir}/rebase-apply" || -d "${gitdir}/rebase-merge" ]]; then
    printf '>R>'
  fi
}

_git_branch() {
  command git rev-parse --is-inside-work-tree &> /dev/null || return 1
  local branch
  if branch=$(command git symbolic-ref -q HEAD); then
    printf '%s' "${branch#refs/heads/}"
  else
    command git rev-parse --short -q HEAD
  fi
}

my_prompt() {
  local retval="$?"
  local branch cwd git dirty staged status color
  if [[ -n "$SSH_CLIENT" ]] || (( UID < 1000)); then
    printf '%s@%s:' "$USER" "$HOSTNAME"
  fi
  printf -v cwd '%s' "${PWD/$HOME/\~}"
  if branch=$(_git_branch); then
    color="$c_green"
    dirty=$(_git_dirty)
    staged=$(git diff --cached)
    head=$(_git_head_status)
    [[ -n "$dirty" ]] && color="$c_red"
    [[ -n "$staged" ]] && status+='✚'
    [[ -n "$head" ]] && status+=" $head"
    printf -v git ' %s[%s%s]%s' "$color" "$branch" "$status" "$c_reset"
  fi
  [[ "$retval" != 0 ]] && printf '%s[%s]%s ' "$c_red" "$retval" "$c_reset"
  printf '%s%s %s$%s ' "$cwd" "$git"
}

set vi-ins-mode-string ''
set vi-cmd-mode-string ':'
set show-mode-in-prompt on

export PS1='$(my_prompt)'

unset prompt_color
unset segment_separator

[[ -f ~/.fzf/shell/key-bindings.bash ]] && source ~/.fzf/shell/key-bindings.bash
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
