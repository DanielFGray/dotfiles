#!/usr/bin/env bash

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

(sleep 0.5 && (
  xmodmap ~/.xmodmap
  xset +fp ~/.fonts
  xset fp rehash
  xsetroot -cursor_name left_ptr
  xrdb -load ~/.Xresources

  setxkbmap -option 'caps:ctrl_modifier'
  xcape -e 'Caps_Lock=Escape'
  setxkbmap -option "grp:switch,grp:shifts_toggle,grp_led:scroll" \
    -layout "us,us(dvorak)"

  syndaemon -t -k -i 2 -d &
  synclient TapButton1=1 \
            VertTwoFingerScroll=1 \
            HorizTwoFingerScroll=1\
            PalmDetect=1
)) &

if [[ -d /etc/X11/xinit/xinitrc.d ]]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [[ -x "$f" ]] && source "$f"
  done
  unset f
fi

exec awesome
