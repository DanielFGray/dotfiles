#!/usr/bin/env bash

declare wm="${2:-xterm}"

xrdb -load ~/.Xresources

while sleep 0.1; do
  if pgrep "$wm"; then
    (
      xsetroot -cursor_name left_ptr

      setxkbmap -option 'caps:ctrl_modifier' \
        -option 'compose:paus' \
        -option 'grp:shifts_toggle,grp_led:scroll' -layout 'us,us(dvorak)'
      xcape -e 'Caps_Lock=Escape'

      synclient TapButton1=1 \
                VertTwoFingerScroll=1 \
                HorizTwoFingerScroll=1 \
                PalmDetect=1
    ) &
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
