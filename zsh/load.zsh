# TODO:
# use 'print -P %F{red}foo%f' for the colors
# (N) glob qualifier instead of manual [[ -f file ]]
# 'typeset -a' to declare the arrays
() {
  (( ${#plugins[@]} > 0 )) || return
  local plugin_path errors loaded_p p p_path p_paths
  errors=()
  plugin_path=( "$HOME/.zsh/plugins" )
  [[ -d "$HOME/.oh-my-zsh/plugins" ]] && plugin_path+=( "$HOME/.oh-my-zsh/plugins" )
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
  unset plugins
  if [[ -n "$errors" ]]; then
    err 'Error loading plugins:'
    printf "${c_red}  %s${c_reset}\n" "${errors[@]}"
    return 1
  fi
}

() {
  [[ -n $theme ]] || return
  local theme_path errors t file found_theme
  theme_path=( "$HOME/.zsh/themes" )
  errors=()
  # [[ -d "$HOME/.oh-my-zsh/themes" ]] && theme_path+=( "$HOME/.oh-my-zsh/themes" )
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
  unset theme
  if [[ -n "$errors" ]]; then
    printf '%sError loading theme:' "${c_red}"
    printf '\n  %s' "${errors[@]}"
    printf '%s\n' "$c_reset"
    return 1
  fi
}
