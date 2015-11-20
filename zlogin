if [[ -z "$SSH_CONNECTION" ]]; then
  if [[ -z "$DISPLAY" &&  $(tty) == '/dev/tty1' ]] ; then
    exec startx
  fi
else
  if tmux ls &> /dev/null; then
    tmux attach
  else
    if command -v tmuxinator &> /dev/null; then
      mux start main
    else
      tmux
    fi
  fi
fi
