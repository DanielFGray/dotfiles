if [[ -n "$SSH_CONNECTION" ]]; then
  if tmux ls &> /dev/null; then
    tmux attach
  else
    if command -v tmuxinator &> /dev/null; then
      mux start main
    else
      tmux
    fi
  fi
else
  if [[ -z "$DISPLAY" &&  $(tty) == '/dev/tty1' ]] ; then
    exec startx
  fi
fi
