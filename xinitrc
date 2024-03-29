#!/usr/bin/env bash


has() {
  local c
  for c; do
    if ! command -v "$c" &> /dev/null; then
      return 1
    fi
  done
}

is_running() {
  pgrep -x "$1" &> /dev/null
}

run_once() {
  if has "$1" && ! is_running "$1"; then
    "$@" &
  fi
}

declare wm="${2:-xterm}"

while sleep 0.1; do
  if is_running "$wm"; then
    [[ -r $HOME/.Xresources ]] && xrdb -load "$HOME/.Xresources"
    xsetroot -cursor_name left_ptr

    xset -b

    setxkbmap -option 'compose:paus'

    xinput set-prop 'pointer:Polo-Leader MANO-603 Touchpad' 'libinput Accel Speed' 0.65
    xinput set-prop 'pointer:Polo-Leader MANO-603 Touchpad' 'libinput Tapping Enabled' 1

    if [[ ! -v MPD_HOST ]] && has 'mpd'; then
      run_once mpd
      run_once mpdscribble
    fi

    if has tmux xmux && [[ "$wm" != *'kde'* ]]; then
      xmux
    fi

    xrandr --output VGA1 --mode 1600x900 --right-of LVDS1
    sleep 2
    nitrogen --restore
    break
  fi
done &

if [[ -d /etc/X11/xinit/xinitrc.d ]]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    source "$f"
  done
  unset f
fi

export DMENU_FONT="Fira Mono-7"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export XDG_CURRENT_DESKTOP=KDE
# export QT_STYLE_OVERRIDE=breeze

exec "$wm"
