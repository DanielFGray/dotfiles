if [ "$SSH_CONNECTION" = "" ]; then
	if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] ; then
		exec startx
	fi
else
	([[ $(tmux ls &> /dev/null) != '' ]] && tmux attach) || mux start main
fi
