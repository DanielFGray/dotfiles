alias xi="xinit awesome"
alias cp="cp -v "
alias mv="mv -v "
alias rm="rm -v "
alias ln="ln -v "
alias curl="curl -v "
alias chown="chown -v "
alias chmod="chmod -v "
alias rename="rename -v "
alias grep="grep --color=auto -E "
alias ls="ls -Fh --color --group-directories-first "
alias l="ls -lgo"
alias la="l -A"
alias cdu="cdu -is -d h "
alias historygrep="history | grep -v 'history' | grep -E "

function cdl { cd $1 ; ls $2 }

function wget { man curl }

function tarpipe { tar czf - $2 | ssh $1 "tar xzvf - $3" }
function rtarpipe { ssh $1 "tar czf - $2" | tar xzvf - }

function soupget { ssh dan@ssh.soupwhale.com "tar czf - $1" | pv --wait | tar xzv }
function soupplay {
	mplayer -playlist <(ssh dan@ssh.soupwhale.com 'find ~/downloads/ -iname "*.mp3"' |
	grep -i "$*" | sort | sed 's|^/home/dan/downloads|http://dan.soupwhale.com/whatisyourquest|')
}

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
	byzanz-record $* ~/pictures/screenshots/$date.gif
	gwenview -f ~/pictures/screenshots/$date.gif
}

function simpleHTTP {
	python -c "import SimpleHTTPServer, SocketServer, BaseHTTPServer; SimpleHTTPServer.test(SimpleHTTPServer.SimpleHTTPRequestHandler, type('Server', (BaseHTTPServer.HTTPServer, SocketServer.ThreadingMixIn, object), {}))" 9090
}
