has() {
  for c; do
    command -v "$c" &> /dev/null || return 1
  done
}

if [[ -n "$SSH_CONNECTION" ]]; then
  if tmux ls &> /dev/null; then
    tmux attach
  else
    if has tmuxinator; then
      mux start main
    else
      tmux
    fi
  fi
else
  if [[ -z "$DISPLAY" && "$TTY" == '/dev/tty1' ]] ; then
    if has fzf wmpicker; then
      exec startx "$(wmpicker)"
    else
      exec startx
    fi
  fi
fi
