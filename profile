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

# if [ -s "$HOME/.rvm/scripts/rvm" ] ; then
# 	source "$HOME/.rvm/scripts/rvm"
# fi

if [ -d "$HOME/.rvm/bin" ] ; then
	PATH="$PATH:$HOME/.rvm/bin"
fi

PATH="/usr/games:$PATH"
PATH="/usr/local/sbin:$PATH"
