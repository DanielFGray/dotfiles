if [ -n "$BASH_VERSION" ]; then
	if [ -f "$HOME/.bashrc" ]; then
		source "$HOME/.bashrc"
	fi
fi

dirs=( "/sbin" "/usr/bin" "/usr/local/sbin" "/usr/games" "$HOME/bin" "$HOME/.local/bin" "$HOME/.gem/ruby/3.1.0/bin" "$HOME/.rvm/bin" "$HOME/.npm/bin" )

for d in "${dirs[@]}"; do;
	if [ -d "$d" ]; then
		export PATH="$d:$PATH"
	fi
done

# vim: ft=sh
