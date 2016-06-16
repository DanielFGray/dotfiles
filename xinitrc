#!/usr/bin/env bash

has() {
  command -v "$1" &> /dev/null
}

wm_picker() {
  known_wms=( openbox-session awesome openbox bspwm xmonad )
  avail_wms=()
  for wm in "${known_wms[@]}"; do
    has "$wm" && avail_wms+=("$wm")
  done
  if has fzf; then
    fzf --reverse --inline-info --cycle < <(printf '%s\n' "${avail_wms[@]}")
  else
    PS3="choose a number between 1 and ${#avail_wms[@]}: "
    select v in "${avail_wms[@]}"; do
      echo "$v";
      break
    done
  fi
}

# wm_choice=$(wm_picker)

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

(sleep 2 && (
  xset +fp ~/.fonts
  xset fp rehash
  xsetroot -cursor_name left_ptr
  xrdb -load ~/.Xresources

  # xmodmap ~/.xmodmap
  # setxkbmap -option 'caps:ctrl_modifier'
  # xcape -e 'Caps_Lock=Escape'
  # xmodmap -e 'keycode 37 ='
  setxkbmap -option 'grp:switch,grp:shifts_toggle,grp_led:scroll' \
    -layout 'us,us(dvorak)'

  mpdscribble

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

# exec "$wm_choice"
exec awesome
