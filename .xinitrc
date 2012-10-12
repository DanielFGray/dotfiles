#!/usr/bin/env bash
xrdb -merge /home/dan/.Xresources
synclient TapButton1=1
case "$1" in
    *)
        exec ck-launch-session dbus-launch $(which $1) ;;
esac
