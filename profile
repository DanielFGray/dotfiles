if [ -n "$BASH_VERSION" ]; then
	if [ -f "$HOME/.bashrc" ]; then
		source "$HOME/.bashrc"
	fi
fi

dirs=(
	"/sbin"
	"/usr/bin"
	"/usr/local/sbin"
	"/usr/games"
	"${HOME}/.rvm/bin"
	"$(ruby -e 'print Gem.user_dir')/bin"
	"${HOME}/.npm/bin"
	"${HOME}/.cabal/bin"
	"${HOME}/.local/bin"
)

for d in "${dirs[@]}"; do
	if [ -d "$d" ]; then
		PATH="$d:$PATH"
	fi
done

export PATH

# vim: ft=sh
