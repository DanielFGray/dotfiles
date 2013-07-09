ZSH="/home/dan/.oh-my-zsh"
ZSH_THEME="clean"
COMPLETION_WAITING_DOTS="true"
#DISABLE_LS_COLORS="true"
plugins=(git zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

#export PAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export EDITOR="vim"

## OS specific commands
if [[ -f /etc/debian_version ]]; then
	if [[ -d /usr/local/share/perl/5.14.2/auto/share/dist/Cope ]]; then
		export PATH="/usr/local/share/perl/5.14.2/auto/share/dist/Cope:$PATH"
	endif
	alias apt-get="sudo apt-get "
	alias canhaz="sudo apt-get install "
	alias updupg="sudo apt-get update; sudo apt-get upgrade"
	alias unlock-dpkg="sudo fuser -vki /var/lib/dpkg/lock; sudo dpkg --configure -a"
	alias compile="make -j3 && sudo checkinstall && echo success! || echo failed"
	function pkgrm() { sudo apt-get purge $* && sudo apt-get autoremove }
	function pkgsearch() { apt-cache search $* | sort | less }
elif [[ -f /etc/arch-release ]]; then
	if [[ -d /usr/share/perl5/vendor_perl/auto/share/dist/Cope ]]; then
		export PATH="/usr/share/perl5/vendor_perl/auto/share/dist/Cope:$PATH"
	endif
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

alias xi="xinit awesome"
alias cp="cp -v "
alias mv="mv -v "
alias rm="rm -v "
alias ln="ln -v "
alias rename="rename -v "
alias grep="grep --color=auto -E "
alias ls="ls --group-directories-first --color=auto -h "
alias cdu="cdu -is -d h "
alias historygrep="history | grep -v 'history' | grep -E "
alias ftp="lftp "
alias sudo="sudo "

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

function cdl { cd $1 ; ls $2 }

function wget { man curl }

function tarpipe { tar czf - $2 | ssh $1 "tar xzvf - $3" }
function rtarpipe { ssh $1 "tar czf - $2" | tar xzvf - }
function soupget { ssh dan@ssh.soupwhale.com "tar czf - $1" | pv --wait | tar xzv }

function pgrep { unbuffer ps aux | grep $1 | grep -v grep }

function newImage {
	convert -background transparent white -fill black -size 400x400 -gravity Center -font Ubuntu-Regular caption:$1 $2
	optipng $2
	qiv $2
}

function importss {
	import $1
	convert -trim $1 $1
	optipng $1
	qiv $1
}

function changeroot {
	sudo cp -L /etc/resolv.conf $1/etc/resolv.conf
	sudo mount -t proc proc $1/proc
	sudo mount -t sysfs sys $1/sys
	sudo mount -o bind /dev $1/dev
	sudo mount -t devpts pts $1/dev/pts/
	sudo chroot $1/ /bin/bash
}

function extract {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)   tar xvjf $1 ;;
			*.tar.gz)    tar xvzf $1 ;;
			*.bz2)       bunzip2 $1 ;;
			*.rar)       unrar x $1 ;;
			*.gz)        gunzip $1 ;;
			*.tar)       tar xvf $1	;;
			*.tbz2)      tar xvjf $1 ;;
			*.tgz)       tar xvzf $1 ;;
			*.zip)       unzip $1 ;;
			*.Z)         uncompress $1;;
			*.7z)        7z x $1 ;;
			*)           echo "'$1' cannot be extracted via >extract<" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

function curltar {
	case $1 in
		*.tar.bz2)   curl -kL $1 | tar xvjf   -  ;;
		*.tar.gz)    curl -kL $1 | tar xvzf   -  ;;
		*.bz2)       curl -kL $1 | bunzip2    -  ;;
		*.rar)       curl -kL $1 | unrar x    -  ;;
		*.gz)        curl -kL $1 | gunzip     -  ;;
		*.tar)       curl -kL $1 | tar xvf    -  ;;
		*.tbz2)      curl -kL $1 | tar xvjf   -  ;;
		*.tgz)       curl -kL $1 | tar xvzf   -  ;;
		*.zip)       curl -kL $1 | unzip      -  ;;
		*.Z)         curl -kL $1 | uncompress -  ;;
		*.7z)        curl -kL $1 | 7z x       -  ;;
		*)           curl -kLO $1
	esac
}

function byzanz {
	date=`date +%F`
	byzanz-record $* /pr0n/pictures/screenshots/$date.gif
	mirage -f /pr0n/pictures/screenshots/$date.gif
}

function simpleHTTP {
	python -c "import SimpleHTTPServer, SocketServer, BaseHTTPServer; SimpleHTTPServer.test(SimpleHTTPServer.SimpleHTTPRequestHandler, type('Server', (BaseHTTPServer.HTTPServer, SocketServer.ThreadingMixIn, object), {}))" 9090
}
