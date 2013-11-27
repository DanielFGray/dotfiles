[ -x $(which fortune) ] && fortune -as

export PAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export EDITOR="vim"

if [ -f /etc/debian_version ]; then
	PERLVER=$(perl --version | /bin/grep -Eom1 '[0-9]\.[0-9]+\.[0-9]+')
	[ -d /usr/local/share/perl/$PERLVER/auto/share/dist/Cope ] && export PATH="/usr/local/share/perl/$PERLVER/auto/share/dist/Cope:$PATH"
	alias apt-get="sudo apt-get "
	alias dpkg="sudo dpkg "
	alias canhaz="apt-get install "
	alias updupg="apt-get update; apt-get upgrade"
	alias unlock-dpkg="sudo fuser -vki /var/lib/dpkg/lock; sudo dpkg --configure -a"
	pkgrm() { sudo apt-get purge $* && sudo apt-get autoremove ;}
	pkgsearch() { apt-cache search $* | sort | less ;}
elif [ -f /etc/arch-release ]; then
	[ -d /usr/share/perl5/vendor_perl/auto/share/dist/Cope ] && export PATH="/usr/share/perl5/vendor_perl/auto/share/dist/Cope:$PATH"
	alias pacman="sudo pacman "
	alias canhaz="pacman -S "
	alias updupg="pacman -Syu "
	alias pkgrm="pacman -Rsu "
	pkgsearch() { unbuffer yaourt -Ss $* | less ;}
elif [ -f /etc/redhat-release ]; then
	alias yum="sudo yum "
	alias canhaz="yum install "
elif [ -f /etc/gentoo-release ]; then
	alias canhaz="sudo emerge -av "
fi

alias cp="cp -v "
alias mv="mv -v "
alias rm="rm -v "
alias ln="ln -v "
alias curl="curl -v "
alias chown="chown -v "
alias chmod="chmod -v "
alias rename="rename -v "
alias grep="grep --color=auto -P "
alias ls="ls -Fh --color --group-directories-first "
alias l="ls -lgo "
alias la="l -A "
alias cdu="cdu -is -d h "
alias historygrep="history | grep -v 'history' | grep "

wget() { man curl ;}
cd() { builtin cd $1 && ls $2 ;}
cat() { (( $# > 1 )) && /bin/cat "$@" ;}

tarpipe() { tar czf - $2 | pv | ssh $1 "tar xzvf - $3" ;}
rtarpipe() { ssh $1 "tar czf - $2" | pv | tar xzvf - ;}

soupget() { ssh dan@ssh.soupwhale.com "tar czf - $1" | pv --wait | tar xzv ;}
soupplay() {
	mplayer -playlist <(ssh dan@ssh.soupwhale.com 'find ~/downloads/ -iname "*.mp3"' |
	grep -i "$*" | sort | sed 's|^/home/dan/downloads|http://dan.soupwhale.com/whatisyourquest|')
}

sprunge() { curl -sF 'sprunge=<-' http://sprunge.us ;}

pgrep() { ps aux | grep $1 | grep -v grep ;}

newImage() {
	convert -background transparent white -fill black -size 400x400 -gravity Center -font Ubuntu-Regular caption:$1 $2 &&
	optipng $2 &&
	qiv $2
}

importss() {
	import $1 &&
	convert -trim $1 $1 &&
	optipng $1 &&
	qiv $1
}

burnusb() {
	sudo dd if=$1 of=$2 bs=4M conv=sync
	sync
	notify-send -u critical 'burnusb' 'done'
}

changeroot() {
	sudo cp -L /etc/resolv.conf $1/etc/resolv.conf
	sudo mount -t proc proc $1/proc
	sudo mount -t sysfs sys $1/sys
	sudo mount -o bind /dev $1/dev
	sudo mount -t devpts pts $1/dev/pts/
	sudo chroot $1/ /bin/bash
}

extract() {
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

curltar() {
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

byzanz() {
	local date=`date '+%F-%s'`
	byzanz-record "$@" ~/images/screenshots/${date}.gif &&
	mirage ~/images/screenshots/${date}.gif
}

simpleHTTP() {
	python -c "import SimpleHTTPServer, SocketServer, BaseHTTPServer; SimpleHTTPServer.test(SimpleHTTPServer.SimpleHTTPRequestHandler, type('Server', (BaseHTTPServer.HTTPServer, SocketServer.ThreadingMixIn, object), {}))" 9090
}

whitenoise() { aplay -c 2 -f S16_LE -r 44100 /dev/urandom ;}

# vim:ft=sh:
