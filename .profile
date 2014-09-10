if [ -n "$BASH_VERSION" ]; then
	if [ -f "$HOME/.bashrc" ]; then
		source "$HOME/.bashrc"
	fi
fi

if [ -d "/sbin" ] ; then
	PATH="/sbin:$PATH"
fi

if [ -d "/usr/sbin" ] ; then
	PATH="/usr/sbin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
	PATH="$HOME/.local/bin:$PATH"
fi

PATH="/usr/games:$PATH"
PATH="/usr/local/sbin:$PATH"
