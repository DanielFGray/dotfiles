export PAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export EDITOR="vim"

if [[ -f /etc/debian_version ]]; then
	PERLVER=$(perl --version | /bin/grep -Eom1 '[0-9]\.[0-9]+\.[0-9]+')
	[[ -d /usr/local/share/perl/$PERLVER/auto/share/dist/Cope ]] && export PATH="/usr/local/share/perl/$PERLVER/auto/share/dist/Cope:$PATH"
	alias canhaz="sudo apt-get install "
	alias updupg="sudo apt-get update; sudo apt-get dist-upgrade"
	alias unlock-dpkg="sudo fuser -vki /var/lib/dpkg/lock; sudo dpkg --configure -a"
	pkgrm() { sudo apt-get purge "$@" && sudo apt-get autoremove ;}
	pkgsearch() { apt-cache search "$@" | sort | less ;}
elif [[ -f /etc/arch-release ]]; then
	[[ -d /usr/share/perl5/vendor_perl/auto/share/dist/Cope ]] && export PATH="/usr/share/perl5/vendor_perl/auto/share/dist/Cope:$PATH"
	alias canhaz="pacaur -S "
	alias updupg="pacaur -Syu "
	alias pkgrm="sudo pacman -Rsu "
	pkgsearch() { unbuffer pacaur -Ss "$@" | less ;}
elif [[ -f /etc/redhat-release ]]; then
	alias yum="sudo yum "
	alias canhaz="yum install "
elif [[ -f /etc/gentoo-release ]]; then
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
alias ls="ls -Fh --color --group-directories-first "
alias l="ls -lgo "
alias la="l -A "
alias cdu="cdu -isdhD "
alias historygrep="history | grep -v 'history' | grep "
alias grep="grep --color=auto --exclude-dir=.cvs --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.svn --color=auto -P "
unset GREP_OPTIONS

cd() {
	if [[ -z "$@" ]]; then
		builtin cd "$HOME" && ls
	else
		local dir="$1"
		shift
		builtin cd "$dir" && ls "$@";
	fi
}

mkd() { mkdir -p "$@" && cd "$1" ;}

wget() { man curl ;}
cat() { (( $# > 1 )) && /bin/cat "$@" ;}

tarpipe() { tar czf - "$2" | pv | ssh "$1" "tar xzvf - $3" ;}
rtarpipe() { ssh $1 "tar czf - $2" | pv | tar xzvf - ;}

txs() {
	if [[ "$1" = "-v" ]]; then
		shift
		tmux split-window -vd "$@"
	else
		tmux split-window -hd "$@"
	fi
}

sprunge() { command curl -sF 'sprunge=<-' http://sprunge.us ;}

pgrep() { ps aux | grep "$1" | grep -v grep ;}

newImage() {
	convert -background transparent white -fill black -size 400x400 -gravity Center -font Ubuntu-Regular caption:"$1" "$2" &&
	optipng "$2" &&
	qiv "$2"
}

burnusb() {
	sudo dd if="$1" of="$2" bs=4M conv=sync
	sync
	ding 'burnusb' 'done'
}

changeroot() {
	sudo cp -L /etc/resolv.conf "$1"/etc/resolv.conf
	sudo mount -t proc proc "$1"/proc
	sudo mount -t sysfs sys "$1"/sys
	sudo mount -o bind /dev "$1"/dev
	sudo mount -t devpts pts "$1"/dev/pts/
	sudo chroot "$1"/ /bin/bash
	while true; do
		printf "unmount $1? "
		read unmount
		case $unmount in
			[Yy]* )
				sudo umount -l "$1"/
				sudo chroot /
				break ;;
			*) break ;;
		esac
	done
}

extract() {
	if [[ -f "$1" ]] ; then
		case "$1" in
			*.tar.bz2)   tar xvjf "$1"  ;;
			*.tar.gz)    tar xvzf "$1"  ;;
			*.bz2)       bunzip2 "$1"   ;;
			*.rar)       unrar x "$1"   ;;
			*.gz)        gunzip "$1"    ;;
			*.tar)       tar xvf "$1"   ;;
			*.tbz2)      tar xvjf "$1"  ;;
			*.tgz)       tar xvzf "$1"  ;;
			*.zip)       unzip "$1"     ;;
			*.Z)         uncompress "$1";;
			*.7z)        7z x "$1"      ;;
			*)           echo "'$1' cannot be extracted via >extract<" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

curltar() {
	case "$1" in
		*.tar.bz2)   \curl -kL "$1" | tar xvjf   -  ;;
		*.tar.gz)    \curl -kL "$1" | tar xvzf   -  ;;
		*.bz2)       \curl -kL "$1" | bunzip2    -  ;;
		*.rar)       \curl -kL "$1" | unrar x    -  ;;
		*.gz)        \curl -kL "$1" | gunzip     -  ;;
		*.tar)       \curl -kL "$1" | tar xvf    -  ;;
		*.tbz2)      \curl -kL "$1" | tar xvjf   -  ;;
		*.tgz)       \curl -kL "$1" | tar xvzf   -  ;;
		*.zip)       \curl -kL "$1" | unzip      -  ;;
		*.Z)         \curl -kL "$1" | uncompress -  ;;
		*.7z)        \curl -kL "$1" | 7z x       -  ;;
		*)           \curl -kLO "$1"
	esac
}

whitenoise() { aplay -c 2 -f S16_LE -r 44100 /dev/urandom ;}

ding() {
	[ -n "$1" ] && notify-send -u critical "$@" &> /dev/null
	paplay ~/downloads/ding.ogg &> /dev/null
}

command -v fortune &> /dev/null && fortune -as

command -v fzf &> /dev/null && command -v ag &> /dev/null && export FZF_DEFAULT_COMMAND='ag -l -g ""'

# vim:ft=sh:
