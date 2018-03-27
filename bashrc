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
  status=$(git status --porcelain  --untracked-files=no 2> /dev/null | tail -n1)
  [[ -n "$status" ]] && printf '*'
}

_git_head_status() {
  local gitdir
  gitdir="$(git rev-parse --git-dir 2> /dev/null)"
  if [[ -f "${gitdir}/MERGE_HEAD" ]]; then
    printf '>M<'
  elif [[ -d "${gitdir}/rebase-apply" || -d "${gitdir}/rebase-merge" ]]; then
    printf '>R>'
  fi
}

_git_branch() {
  git rev-parse --is-inside-work-tree &> /dev/null || return 1
  local branch
  if branch=$(git symbolic-ref -q HEAD); then
    printf '%s' "${branch#refs/heads/}"
  else
    git rev-parse --short -q HEAD
  fi
}

my_prompt() {
  retval="$?"
  local branch cwd git dirty staged status userfg gitfg err user linefg
  err=''
  printf -v cwd '%s' "${PWD/$HOME/\~}"
  linefg="${colors[blue]}"
  if branch=$(_git_branch); then
    gitfg="${colors[green]}"
    dirty=$(_git_dirty)
    staged=$(git diff --cached)
    head=$(_git_head_status)
    [[ -n "$dirty" ]] && gitfg="${colors[red]}"
    [[ -n "$staged" ]] && status+='+'
    [[ -n "$head" ]] && status+="^$head"
    printf -v git ']─[%s%s%s%s' "$gitfg" "$branch" "$status" "${colors[reset]}"
  fi

  if [[ -n "$SSH_CLIENT" || $UID != 1000 ]]; then
    userfg="${colors[green]}"
    [[ $UID = 0 ]] && userfg="${colors[red]}"
    printf -v user '─[%s%s@%s%s]' "${userfg}" "$USER" "$HOSTNAME" "${colors[reset]}"
  fi
  [[ "$retval" != 0 ]] && printf -v err '─[%s%s%s]' "${colors[red]}" "$retval" "${colors[reset]}"
  printf '┌─[%s%s]\n└%s%s─» ' "$cwd" "$git" "$err" "$user"
}

[[ -n $DISPLAY ]] && {
  set vi-ins-mode-string ''
  set vi-cmd-mode-string ':'
  set show-mode-in-prompt on
}

export -f my_prompt
export PS1='$(my_prompt)'

unset prompt_color
unset segment_separator

[[ -f ~/.fzf/shell/key-bindings.bash ]] && source ~/.fzf/shell/key-bindings.bash
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
