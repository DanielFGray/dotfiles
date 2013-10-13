#!/bin/bash

while true; do
	read -e -p 'sudo apt-get install ' -i "$(tr '\n' ' ' < ~/dotfiles/packages)" install
	case $install in
	'' ) break ;;
	* )
		echo sudo apt-get install $install
		break ;;
	esac
done

if ! type 'vim' &> /dev/null; then
	echo 'warning: vim not found'
else
	while true; do
		read -e -p 'install vim plugins? (y/n) ' vimplugins
		case $vimplugins in
			[Yy]* )
				echo ln -vfs ~/dotfiles/.{vimrc,zshrc,tmux.conf} ~
				echo mkdir -vp ~/.vim/{bundle,colors,cache,undo,backups,swaps}
				echo git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
				echo vim +NeoBundleUpdate +q
				break ;;
			* ) break ;;
		esac
	done
fi

if ! type 'zsh' &> /dev/null; then
	echo 'warning: zsh not found'
else
	while true; do
		read -e -p 'git clone oh-my-zsh and plugins? (y/n) ' zshconf
		case $zshconf in
			[Yy]* )
				echo git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
				echo mkdir -vp ~/.oh-my-zsh/custom/plugins
				echo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
				break ;;
			* ) break ;;
		esac
	done
fi
