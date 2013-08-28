source $HOME/.profile
if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] ; then
	xinit awesome &> ~/xsession.log
fi
