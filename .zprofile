[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/local/bin" ]] && export PATH="$HOME/local/bin:$PATH"

if [ "$SSH_CONNECTION" = "" ]; then
<<<<<<< Updated upstream
=======
	export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
>>>>>>> Stashed changes
	if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] ; then
		if [ -f /etc/debian_version ]; then
			xinit awesome &> .xsession.log &
		else
			startx &> .xsession.log &
		fi
	fi
else
	([[ $(/home/dan/local/bin/tmux ls 2>/dev/null) != '' ]] && tmux attach) || tmux
fi
