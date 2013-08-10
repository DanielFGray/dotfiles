fortune -as
if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] ; then
	xinit startkde &> ~/xsession.log
fi
