#!/usr/bin/env bash

cd "${BASH_SOURCE%/*}"
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
	if [[ -d "${path}" ]]; then
		if [[ -d "${path}/.git" ]]; then
			echo "git -C "${path}" pull"
			git -C "${path}" pull
		else
			ask "no .git found in ${path}, delete entire folder and clone repo?" && rm -fr "${path}"
		fi
	fi
	if [[ ! -d "$path" ]]; then
		mkdir -p "${path%/}"
		git clone "$url" "${path}"
	fi
}

if ! has 'git' || ! has 'curl'; then
	err 'git and curl both required'
	exit 1
fi

if ask 'symlink profile and bash_{aliases,utils}?'; then
	backup_then_symlink 'profile' 'bash_aliases' 'bash_utils'
fi

if has 'vim' && ask 'install vimrc?'; then
	backup_then_symlink 'vimrc'
fi

if has 'zsh' && ask 'git clone oh-my-zsh and plugins?'; then
	library 'https://github.com/robbyrussell/oh-my-zsh.git' "${HOME}/.oh-my-zsh"
	library 'https://github.com/zsh-users/zsh-syntax-highlighting.git' "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
fi

if has 'tmux' && ask 'symlink tmux.conf and tpm?'; then
	backup_then_symlink 'tmux.conf'
	library 'https://github.com/tmux-plugins/tpm' "${HOME}/.tmux/plugins/tpm"
fi

if ask 'symlink gitconfig {gem,npm}rc?'; then
	backup_then_symlink 'gitconfig' 'npmrc' 'gemrc'
fi

if has 'X'; then
	if has 'xmodmap' && ask 'symlink xmodmap?'; then
		backup_then_symlink 'xmodmap'
		xmodmap ~/.xmodmap
	fi

	if has 'xrdb' && ask 'symlink Xresources?'; then
		backup_then_symlink 'Xresources'
		xrdb -load ~/.Xresources
	fi

	if has 'fc-cache' && ask 'install tewi?'; then
		mkdir ${verbose:+-v} -p ~/build ~/.fonts
		cd ~/build
		library 'https://github.com/lucy/tewi-font' "${HOME}/build/tewi-font"
		cd ~/build/tewi-font
		make
		cp ${verbose:+-v} *.pcf ~/.fonts
		mkfontdir ~/.fonts; xset +fp ~/.fonts ; xset fp rehash; fc-cache -f
		cd "$thisdir"
	fi
fi

info 'done!'
