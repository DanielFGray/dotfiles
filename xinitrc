#!/usr/bin/env bash

has() {
  command -v mpd &> /dev/null
}

is_running() {
  pgrep -x "$1" &> /dev/null
}

declare wm="${2:-xterm}"

while sleep 0.1; do
  if is_running "$wm"; then
    xrdb -load ~/.Xresources
    xsetroot -cursor_name left_ptr

    setxkbmap -option 'caps:ctrl_modifier' \
      -option 'compose:paus' \
      -option 'grp:shifts_toggle,grp_led:scroll' -layout 'us,us(dvorak)'
    xcape -e 'Caps_Lock=Escape'
    syndaemon -tkKd -i 2
    synclient TapButton1=1 \
              VertTwoFingerScroll=1 \
              HorizTwoFingerScroll=1 \
              PalmDetect=1

    if [[ -z "$MPD_HOST" ]] && has 'mpd'; then
      is_running 'mpd' || mpd
      if has 'mpdscribble'; then
        is_running 'mpdscribble' || mpdscribble
      fi
    fi

    has xmux && [[ "$wm" != *'kde'* ]] && xmux

    break
  fi
done &

if [[ -d /etc/X11/xinit/xinitrc.d ]]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    source "$f"
  done
  unset f
fi

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
exec "$wm"
