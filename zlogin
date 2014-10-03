if [ "$SSH_CONNECTION" = "" ]; then
	if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] ; then
		if [ -f /etc/debian_version ]; then
			exec xinit awesome &> .xsession.log
		else
			exec startx &> .xsession.log
		fi
	fi
else
	([[ $(tmux ls 2>/dev/null) != '' ]] && tmux attach) || tmux
fi
