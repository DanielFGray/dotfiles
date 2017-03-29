parse_git_dirty() {
  local dirt
  dirt=$(command git status --porcelain --untracked-files=no 2> /dev/null | tail -n1)
  [[ -n "$dirt" ]]
}

git_info() {
  # needs indicators for staged changes, etc
  local ref dirty repo_path mode
  ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
  repo_path=$(git rev-parse --git-dir 2>/dev/null)
  branch="${ref#refs/heads/}"
  parse_git_dirty && branch="%{$fg[red]%}$branch%{$reset_color%}"

  if [[ -e "${repo_path}/BISECT_LOG" ]]; then
    mode=" <B>"
  elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
    mode=" >M<"
  elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
    mode=" >R>"
  fi

  setopt promptsubst
  autoload -Uz vcs_info

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' get-revision true
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:*' stagedstr '+'
  zstyle ':vcs_info:*' unstagedstr '*'
  zstyle ':vcs_info:*' formats ' %u%c'
  zstyle ':vcs_info:*' actionformats ' %u%c'
  vcs_info
  printf '[%s%s%s]' "${branch}" "${vcs_info_msg_0_%%}" "${mode}"
}

function get_host {
  [[ -n "$SSH_CLIENT" ]] &&
    printf '@%m'
}

PROMPT='$(get_host)%# '
RPROMPT='$(git_info)%~'
