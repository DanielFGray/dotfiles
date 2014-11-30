if [ "$SSH_CONNECTION" = "" ]; then
	if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] ; then
		exec startx
	fi
else
	([[ $(tmux ls 2>/dev/null) != '' ]] && tmux attach) || tmux
fi
