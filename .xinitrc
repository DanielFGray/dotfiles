#!/bin/sh
xrdb -merge /home/dan/.Xresources
case "$1" in
	'openbox') 
		exec ck-launch-session openbox-session ;;
	'awesome')
		lxsession &
		exec ck-launch-session $(which $1) ;;
	*)
		exec ck-launch-session $(which $1) ;;
esac
