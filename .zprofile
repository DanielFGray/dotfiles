source $HOME/.profile
if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] ; then
	if [ -f /etc/debian_version ]; then
		xinit awesome &> .xsession.log &
	else
		startx &> .xsession.log &
	fi
fi
