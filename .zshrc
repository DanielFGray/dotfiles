ZSH="/home/dan/.oh-my-zsh"
ZSH_THEME="flazz"
COMPLETION_WAITING_DOTS="true"
#DISABLE_LS_COLORS="true"
plugins=(git zsh-syntax-highlighting vi-mode)
source $ZSH/oh-my-zsh.sh

#[[ -d "$HOME/local/bin" ]] && export PATH="$HOME/local/bin:$PATH"
#[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
#[[ -d "$HOME/.rvm/bin" ]] && export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

#export PAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export EDITOR="vim"

## OS specific commands
if [[ -f /etc/debian_version ]]; then
	if [[ -d /usr/local/share/perl/5.14.2/auto/share/dist/Cope ]]; then
		export PATH="/usr/local/share/perl/5.14.2/auto/share/dist/Cope:$PATH"
	fi
	alias apt-get="sudo apt-get "
	alias canhaz="sudo apt-get install "
	alias updupg="sudo apt-get update; sudo apt-get upgrade"
	alias unlock-dpkg="sudo fuser -vki /var/lib/dpkg/lock; sudo dpkg --configure -a"
	alias compile="make -j3 && sudo checkinstall && echo success! || echo failed"
	function pkgrm() { sudo apt-get purge $* && sudo apt-get autoremove }
	function pkgsearch() { apt-cache search $* | sort | less }
elif [[ -f /etc/arch-release ]]; then
	if [[ -d /usr/share/perl5/site_perl/auto/share/dist/Cope ]]; then
		export PATH="/usr/share/perl5/site_perl/auto/share/dist/Cope:$PATH"
	fi
	alias pacman="sudo pacman "
	alias canhaz="sudo pacman -S "
	alias updupg="sudo pacman -Syu "
	alias pkgrm="sudo pacman -Rsu "
	function pkgsearch() { unbuffer yaourt -Ss $* | less }
elif [[ -f /etc/redhat-release ]]; then
	alias canhaz="sudo yum install "
	alias yum="sudo yum "
elif [[ -f /etc/gentoo-release ]]; then
	alias canhaz="sudo emerge -av "
fi

alias -s png=qiv
alias -s jpg=qiv
alias -s gif=qiv
alias -s mp3=mplayer
alias -s avi=mplayer
alias -s wmv=mplayer
alias -s mpg=mplayer
alias -s pdf=apvlv

bindkey -v
bindkey "^[[A"  history-search-backward
bindkey "^[[B"  history-search-forward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

source $HOME/dotfiles/.alias.sh
