#!/usr/bin/env bash

cd "${BASH_SOURCE%/*}" || exit
declare thisdir="$PWD"
declare verbose

source "${thisdir}/bash_utils"

while true; do
	case "$1" in
		'-v'|'--verbose') verbose=true ;;
		*) break ;;
	esac
	shift
done

backup_then_symlink() {
	for f in "$@"; do
		if [[ -L "${HOME}/.${f}" ]]; then
			rm "${HOME}/.${f}"
		fi
		if [[ -f "${HOME}/.${f}" ]]; then
			mv ${verbose:+-v} "${HOME}/.${f}" "${HOME}/old.${f}"
		fi
		ln ${verbose:+-v} -s "${thisdir}/${f}" "${HOME}/.${f}"
	done
}

library() {
	url="$1"
	path="$2"
	if [[ -d "$path" ]]; then
		if [[ -d "${path}/.git" ]]; then
			echo "git -C ${path} pull"
			git -C "$path" pull
		elif ask "no .git found in ${path}, delete entire folder and clone repo?"; then
			rm -fr ${verbose:+-v} "$path"
		fi
	fi
	if [[ ! -d "$path" ]]; then
		mkdir -p ${verbose:+-v} "${path%/*}"
		git clone "$url" "$path"
	fi
}

if ! has 'git' || ! has 'curl'; then
	err 'git and curl both required'
	exit 1
fi

if [[ ! -L ~/.bash_aliases ]] && ask 'symlink profile and bash_{aliases,utils}?'; then
	backup_then_symlink profile bash_aliases bash_utils
fi

if [[ ! -L ~/.vimrc ]] && has vim && ask 'install vimrc?'; then
	backup_then_symlink vimrc
fi

if [[ ! -L ~/.zshrc ]] && has zsh && ask 'git clone oh-my-zsh and plugins?'; then
	library https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh
	library https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	backup_then_symlink zshrc zprofile zlogin
else
	echo '~/.zshrc already symlinked'
fi

if [[ ! -L ~/.tmux.conf ]] && has tmux && ask 'symlink tmux.conf and tpm?'; then
	backup_then_symlink tmux.conf
	library https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
else
	echo '~/.tmux.conf already symlinked'
fi

if [[ ! -L ~/.inputrc ]] && ask 'symlink inputrc gitconfig {gem,npm}rc?'; then
	backup_then_symlink inputrc gitconfig npmrc gemrc
else
	echo '~/.inputrc already symlinked'
fi

if has X; then
	export DISPLAY=:0

	if [[ ! -L ~/.xmodmap ]] && has xmodmap && ask 'install and run xmodmap?'; then
		backup_then_symlink xmodmap
		xmodmap ${HOME}/.xmodmap
	else
		echo '~/.xmodmap already symlinked'
	fi

	if [[ ! -L ~/.Xresources ]] && has xrdb && ask 'symlink Xresources?'; then
		backup_then_symlink Xresources
		xrdb -load ${HOME}/.Xresources
	else
		echo '~/.Xresources already symlinked'
	fi

	if [[ ! -f ~/.fonts/FantasqueSansMono-Regular.ttf  ]] && has fc-cache && ask 'install fonts?'; then
		mkdir ${verbose:+-v} -p ${HOME}/{build,.fonts}
		unzip ${thisdir}/../downloads/fantasque-sans-mono.zip '*.ttf' -d ~/.fonts
		mkfontdir ${HOME}/.fonts
		xset +fp ${HOME}/.fonts
		xset fp rehash
		fc-cache -f ${verbose:+-v}
		cd "$thisdir"
	fi

fi
