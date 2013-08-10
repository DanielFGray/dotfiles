#!/usr/bin/env bash

synclient TapButton1=1
synclient VertTwoFingerScroll=1
synclient HorizTwoFingerScroll=1
synclient EmulateTwoFingerMinW=20
synclient EmulateTwoFingerMinZ=48

xrdb -load ~/.Xresources

case "$1" in
    *)
        exec dbus-launch $(which $1) ;;
esac
