#!/usr/bin/env bash

source ~/.bash_utils

cd "${BASH_SOURCE%/*}"
thisdir="$PWD"
verbose=false

while true; do
	case "$1" in
		'-v'|'--verbose') verbose=true ;;
		*) break ;;
	esac
	shift
done

backup_then_symlink() {
	for f in "$@"; do
		if [[ -f "${HOME}/.${f}" ]]; then
			mv ${verbose:+-v} "${HOME}/.${f}" "${HOME}/old.${f}"
		fi
		ln ${verbose:+-v} -s "${thisdir}/${f}" "${HOME}/.${f}"
	done
}

if ! has 'git' || ! has 'curl'; then
	err 'git and curl both required'
	exit 1
fi

if ask 'symlink profile and bash_{aliases,utils}?'; then
	backup_then_symlink 'profile' 'bash_aliases' 'bash_utils'
fi

if has 'vim' && ask 'install vim plugins?'; then
	mkdir ${verbose:+-v} -p ${HOME}/.vim/{autoload,bundle,cache,undo,backups,swaps}
	if [[ ! -f ${HOME}/.vim/autoload/plug.vim ]]; then
		curl ${verbose:+-v} -fLo ${HOME}/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	fi
	backup_then_symlink 'vimrc'
fi

if has 'zsh' && ask 'git clone oh-my-zsh and plugins?'; then
	if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
		git clone https://github.com/robbyrussell/oh-my-zsh.git "${HOME}/.oh-my-zsh"
	fi
	if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
		mkdir -p "${HOME}/.oh-my-zsh/custom/plugins"
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
	fi
	backup_then_symlink 'zshrc' 'zprofile' 'zlogin'
fi

if has 'tmux' && ask 'symlink tmux.conf and install plugins?'; then
	if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
		mkdir ${verbose:+-v} -vp "${HOME}/.tmux/plugins"
		git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
	fi
	[[ -f "${HOME}/.tmux.conf" ]] && mv "${HOME}/.tmux.conf" "${HOME}/old.tmux.conf"
	if ask 'use remote tmux conf?'; then
		ln ${verbose:+-v} -s "${thisdir}/remote.tmux.conf" "${HOME}/.tmux.conf"
	else
		ln ${verbose:+-v} -s "${thisdir}/local.tmux.conf" "${HOME}/.tmux.conf"
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
	mkdir ${verbose:+-v} -p ~/build ~/.fonts
	cd ~/build
	if [[ ! -d "${HOME}/build/tewi-font" ]]; then
		git clone https://github.com/lucy/tewi-font
		cd ~/build/tewi-font
	else
		cd ~/build/tewi-font
		git pull
	fi
	make
	cp ${verbose:+-v} *.pcf ~/.fonts
	mkfontdir ~/.fonts; xset +fp ~/.fonts ; xset fp rehash; fc-cache -f
	cd "$thisdir"
fi
