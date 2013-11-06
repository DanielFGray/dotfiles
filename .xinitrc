#!/usr/bin/env bash

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

synclient TapButton1=1
synclient VertTwoFingerScroll=1
synclient HorizTwoFingerScroll=1

(sleep 1 && (
	xmodmap ~/.xmodmap
	xrdb -load ~/.Xresources
	xset +fp ~/.fonts; xset fp rehash;
	syndaemon -t -k -i 2 -d &
)) &

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

if [ -f /etc/debian_version ]; then
	exec ck-launch-session dbus-launch $1
elif [ -f /etc/arch-release ]; then
	exec dbus-launch awesome -c $HOME/.config/awesome/35.lua
fi
