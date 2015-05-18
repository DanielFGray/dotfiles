#!/usr/bin/env bash

cd "${BASH_SOURCE%/*}"
thisdir="$PWD"

has() {
	if [[ $1 == '-s' ]]; then
		silent=true
		shift
	fi
	if type "$1" &> /dev/null; then
		return 0
	else
		[[ "$silent" != true ]] && err "$1 not found"
		return 1
	fi
}

err() {
	if [[ -t 0 ]]; then
		echo >&2 "$*"
	else
		zenity --error --text="$*" 2> /dev/null
	fi
}

msg() {
	if [[ -t 0 ]]; then
		echo "$*"
	else
		zenity --info --text="$*" 2> /dev/null
	fi
}

ask() {
	if [[ -t 0 ]]; then
		prompt='Y/n'
		read -n1 -p "$* [$prompt] " ans
		echo ''
		if [[ ${ans^} == Y* ]]; then
			return 0
		else
			return 1
		fi
	else
		zenity --question --text="$*" 2> /dev/null
	fi
}

backup_then_symlink() {
	for f in "$@"; do
		if [[ -f "${HOME}/.${f}" ]]; then
			mv -v "${HOME}/.${f}" "${HOME}/old.${f}"
		fi
		ln -vs "${thisdir}/${f}" "${HOME}/.${f}"
	done
}

if ! has -s 'git' || ! has -s 'curl'; then
	err 'git and curl both required'
	exit 1
fi

if ask 'symlink profile and bash_aliases?'; then
	backup_then_symlink 'profile' 'bash_aliases'
fi

if has 'vim' && ask 'install vim plugins?'; then
	mkdir -vp ${HOME}/.vim/{autoload,bundle,cache,undo,backups,swaps}
	if [[ ! -f ${HOME}/.vim/autoload/plug.vim ]]; then
		curl -fLo ${HOME}/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	fi
	backup_then_symlink 'vimrc'
fi

if has 'zsh' && ask 'git clone oh-my-zsh and plugins?'; then
	if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
		git clone https://github.com/robbyrussell/oh-my-zsh.git "${HOME}/.oh-my-zsh"
	fi
	if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
		mkdir -vp "${HOME}/.oh-my-zsh/custom/plugins"
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
	fi
	backup_then_symlink 'zshrc' 'zprofile' 'zlogin'
fi

if has 'tmux' && ask 'symlink tmux.conf and install plugins?'; then
	if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
		mkdir -vp "${HOME}/.tmux/plugins"
		git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
	fi
	[[ -f "${HOME}/.tmux.conf" ]] && mv "${HOME}/.tmux.conf" "${HOME}/old.tmux.conf"
	if ask 'use remote tmux conf?'; then
		ln -vs "${thisdir}/remote.tmux.conf" "${HOME}/.tmux.conf"
	else
		ln -vs "${thisdir}/local.tmux.conf" "${HOME}/.tmux.conf"
	fi
fi

if has 'xmodmap' && ask 'symlink xmodmap?'; then
	backup_then_symlink 'xmodmap'
	xmodmap ~/.xmodmap
fi

if has 'xrdb' && ask 'symlink Xresources?'; then
	backup_then_symlink 'Xresources'
	xrdb -load ~/.Xresources
fi

if has 'fc-cache' && ask 'install tewi?'; then
	mkdir -p ~/build ~/.fonts
	cd ~/build
	if [[ ! -d "${HOME}/build/tewi-font" ]]; then
		git clone https://github.com/lucy/tewi-font
		cd ~/build/tewi-font
	else
		cd ~/build/tewi-font
		git pull
	fi
	make
	cp *.pcf ~/.fonts
	mkfontdir ~/.fonts; xset +fp ~/.fonts ; xset fp rehash; fc-cache -f
	cd "$thisdir"
fi
