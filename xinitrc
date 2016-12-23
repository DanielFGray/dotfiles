#!/usr/bin/env bash

declare wm="${2:-xterm}"

has() {
  command -v "${1%% *}" &> /dev/null
}

xrdb -load ~/.Xresources

(sleep 2 && (
  xsetroot -cursor_name left_ptr

  setxkbmap -option 'grp:switch,grp:shifts_toggle,grp_led:scroll' \
    -layout 'us,us(dvorak)'
  setxkbmap -option 'caps:ctrl_modifier' -option 'compose:paus'
  xcape -e 'Caps_Lock=Escape'

  synclient TapButton1=1 \
            VertTwoFingerScroll=1 \
            HorizTwoFingerScroll=1 \
            PalmDetect=1
) &)

if [[ -d /etc/X11/xinit/xinitrc.d ]]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    source "$f"
  done
  unset f
fi

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
exec "$wm"
