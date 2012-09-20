ZSH=/home/dan/.oh-my-zsh
ZSH_THEME="clean"
COMPLETION_WAITING_DOTS="true"
#DISABLE_LS_COLORS="true"
plugins=(git zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

export EDITOR="vim"

alias ls="ls --group-directories-first --color=auto -H"
alias grep="grep --color=auto"
alias canhaz="sudo apt-get install"
alias updupg="sudo apt-get update; sudo apt-get upgrade"
alias dirktop="scrot -d 1 -e 'optipng \$f; qiv -f -i \$f &'"
alias compile="make -j3 && sudo make install && echo success! || echo failed"
alias unlock-dpkg="sudo fuser -vki /var/lib/dpkg/lock; sudo dpkg --configure -a"
alias pacman="sudo pacman-color"
alias ed="ed -p 'ed> '"
alias cp="cp -v"
alias mv="mv -v"
alias rm="rm -v"
alias ln="ln -v"
alias -s png=qiv
alias -s jpg=qiv
alias -s gif=qiv
alias -s mp3=mplayer
alias -s avi=mplayer
alias -s wmv=mplayer
alias -s mpg=mplayer
alias -s mpeg=mplayer

bindkey -v
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

function cdl() {
        cd $1
	ls $2
}
function newImage() {
	convert -background white -fill black -size 400x400 -gravity Center caption:$1 $2
	optipng $2
	qiv $2
}

function changeroot() {
	sudo cp -L /etc/resolv.conf $1/etc/resolv.conf
	sudo mount -t proc proc $1/proc
	sudo mount -t sysfs sys $1/sys
	sudo mount -o bind /dev $1/dev
	sudo mount -t devpts pts $1/dev/pts/
	sudo chroot $1/ /bin/bash
}

function tarpipe() {
	tar czf - $2 | ssh $1 'tar xzvf - $3'
}

function apt-search() {
	apt-cache search $*|sort|less
}

function extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1        ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1       ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1     ;;
            *.tar)       tar xvf $1        ;;
            *.tbz2)      tar xvjf $1      ;;
            *.tgz)       tar xvzf $1       ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1    ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

function simpleHTTP() {
	python -c "import SimpleHTTPServer, SocketServer, BaseHTTPServer; SimpleHTTPServer.test(SimpleHTTPServer.SimpleHTTPRequestHandler, type('Server', (BaseHTTPServer.HTTPServer, SocketServer.ThreadingMixIn, object), {}))" 9090
}
