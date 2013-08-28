source $HOME/.profile
if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] ; then
	startx
fi
