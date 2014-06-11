#!/bin/bash

#if [ -z $(sudo -l 2>&1 | grep -P '^Sorry,|incorrect' | wc -l) ]; then
#	while true; do
#		# parse packages.txt for gui/cli, ask for each group
#		read -e -p 'packages to install: ' -i "$(tr '\n' ' ' < ~/dotfiles/packages)" install
#		case $install in
#		'' ) break ;;
#		* )
#			if [ -f /etc/debian_version ]; then
#				sudo apt-get install $install
#			elif [ -f /etc/redhat-release ]; then
#				sudo yum install $install
#			elif [ -f /etc/arch-release ]; then
#				sudo pacman -S $install
#			elif [ -f /etc/gentoo-release ]; then
#				sudo emerge -avl $install
#			else
#				echo "I don't know how to install"
#			fi
#			break ;;
#		esac
#	done
#fi

#TODO: mv existing
ln -sv ~/dotfiles/.{bashrc,bash_aliases,profile} ~

if ! type 'vim' &> /dev/null; then
	echo 2> 'vim not found'
else
	while true; do #TODO: Why is this necessary?
		read -e -p 'install vim plugins? (y/n) ' vimplugins
		case $vimplugins in
			[Yy]* )
				#TODO: mv existing
				ln -vs ~/dotfiles/.vimrc ~/.vimrc
				mkdir -vp ~/.vim/{bundle,colors,cache,undo,backups,swaps}
				git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle #TODO: if dir exists : cd && git pull
				vim +NeoBundleUpdate +q
				break ;;
			* ) break ;;
		esac
	done
fi

if ! type 'zsh' &> /dev/null; then
	echo 2> 'zsh not found'
else
	while true; do
		read -e -p 'git clone oh-my-zsh and plugins? (y/n) ' zshconf
		case $zshconf in
			[Yy]* )
				git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh #TODO: if dir exists : cd && git pull
				mkdir -vp ~/.oh-my-zsh/custom/plugins
				git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins #TODO: if dir exists : cd && git pull
				#TODO: mv existing
				ln -vs ~/dotfiles/.{zshrc,zprofile,zlogin} ~
				break ;;
			* ) break ;;
		esac
	done
fi

if !type 'awesome' &> /dev/null; then
	echo 2> 'awesome not found'
else
	while true; do
		read -e -p 'symlink awesome dir? (y/n) ' awesomeconf
		case $awesomeconf in
			[Yy]* )
				#TODO: mv existing
				ln -sf ~/dotfiles/.config/awesome ~/.config
				break ;;
			* ) break ;;
		esac
	done
fi

if !type 'tmux' &> /dev/null; then
	echo 2> 'tmux not found'
else
	while true; do
		read -e -p 'symlink tmux.conf? (y/n) ' tmuxconf1
		case $tmuxconf1 in
			[Yy]* )
				#TODO: mv existing
				read -e -p 'local or remote tmux.conf? (l/r) ' tmuxconf2
				case $tmuxconf2 in
					[Ll]* )
						ln -sv ~/dotfiles/local.tmux.conf ~/.tmux.conf
						break ;;
					[Rr]* )
						ln -sv ~/dotfiles/remote.tmux.conf ~/.tmux.conf
						break ;;
					* ) break ;;
				esac
				break ;;
			* ) break ;;
		esac
	done
fi
