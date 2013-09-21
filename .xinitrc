#!/usr/bin/env bash

synclient TapButton1=1
synclient VertTwoFingerScroll=1
synclient HorizTwoFingerScroll=1
synclient EmulateTwoFingerMinW=20
synclient EmulateTwoFingerMinZ=48

(sleep 2 && (xrdb -load ~/.Xresources; xset +fp ~/.fonts; xset fp rehash)) &

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

if [[ -f /etc/arch-release ]]; then
	exec awesome
elif [[ -f /etc/debian_version ]]; then
	exec ck-launch-session dbus-launch awesome
fi
