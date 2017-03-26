_fancy-ctrl-z () {
  if (( #BUFFER == 0 )); then
    BUFFER='fg'
    zle accept-line
  else
    zle push-input
  fi
}
zle -N _fancy-ctrl-z
bindkey '^Z' _fancy-ctrl-z
