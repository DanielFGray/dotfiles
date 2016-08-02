has() {
  command -v "$1" &> /dev/null
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
  if [[ -z "$DISPLAY" &&  $(tty) == '/dev/tty1' ]] ; then
    if has wmpicker; then
      exec wmpicker
    else
      exec startx
    fi
  fi
fi
