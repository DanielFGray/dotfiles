#!/usr/bin/env bash

thisdir="${BASH_SOURCE%/*}"

read -e -p 'symlink profile and bash_aliases? (y/n) ' defaults
case $defaults in
	[Yy]* )
		files=( '.profile' '.bash_aliases' )
		for f in "${files[@]}"; do
			if [[ -f "${HOME}/$f" ]]; then
				mv -v "${HOME}/${f}" "${HOME}/old${f}"
			fi
		done
		ln -vs "${thisdir}/bash_aliases" "${HOME}/.bash_aliases"
		ln -vs "${thisdir}/profile" "${HOME}/.profile"
		;;
	* ) ;;
esac

if ! type 'vim' &> /dev/null; then
	echo >&2 'vim not found'
else
	read -e -p 'install vim plugins? (y/n) ' vimplugins
	case $vimplugins in
		[Yy]* )
			[[ -f "${HOME}/.vimrc" ]] && mv "${HOME}/.vimrc" "${HOME}/old.vimrc"
			ln -vs "${thisdir}/vimrc" "${HOME}/.vimrc"
			mkdir -vp "${HOME}/.vim/{autoload,bundle,colors,cache,undo,backups,swaps}"
			curl -fLo https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > $HOME/.vim/autoload/plug.vim
			;;
		* ) ;;
	esac
fi

if ! type 'zsh' &> /dev/null; then
	echo >&2 'zsh not found'
else
	read -e -p 'git clone oh-my-zsh and plugins? (y/n) ' zshconf
	case $zshconf in
		[Yy]* )
			if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
				git clone https://github.com/robbyrussell/oh-my-zsh.git "${HOME}/.oh-my-zsh"
			fi
			if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
				mkdir -vp "${HOME}/.oh-my-zsh/custom/plugins"
				git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
			fi
			zshfiles=( '.zshrc' '.zprofile' '.zlogin' )
			for f in "${zshfiles[@]}"; do
				if [[ -f "${HOME}/$f" ]]; then
					mv -v "${HOME}/${f}" "${HOME}/old${f}"
				fi 
			done
			;;
		* ) ;;
	esac
fi

if ! type 'tmux' &> /dev/null; then
	echo >&2 'tmux not found'
else
	read -e -p 'symlink tmux.conf and install plugins? (y/n) ' tmuxconf1
	case $tmuxconf1 in
		[Yy]* )
			if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
				mkdir -vp "${HOME}/.tmux/plugins"
				git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
			fi
			[[ -f "${HOME}/.tmux.conf" ]] && mv "${HOME}/.tmux.conf" "${HOME}/old.tmux.conf"
			read -e -p 'local or remote tmux.conf? (l/r) ' tmuxconf2
			case $tmuxconf2 in
				[Ll]* )
					ln -vs "${thisdir}/local.tmux.conf" "${HOME}/.tmux.conf"
					;;
				[Rr]* )
					ln -vs "${thisdir}/remote.tmux.conf" "${HOME}/.tmux.conf"
					;;
				* ) ;;
			esac
			;;
		* ) ;;
	esac
fi

if ! type 'awesome' &> /dev/null; then
	echo >&2 'awesome not found'
else
	read -e -p 'symlink awesome dir? (y/n) ' awesomeconf
	case $awesomeconf in
		[Yy]* )
			ln -vs "${thisdir}/config/awesome" "${HOME}/.config"
			;;
		* ) ;;
	esac
fi

if ! type 'openbox' &> /dev/null; then
	echo >&2 'openbox not found'
else
	read -e -p 'symlink openbox dir? (y/n) ' openboxconf
	case $openboxconf in
		[Yy]* )
			ln -vs "${thisdir}/config/openbox" "${HOME}/.config"
			;;
		* ) ;;
	esac
fi
