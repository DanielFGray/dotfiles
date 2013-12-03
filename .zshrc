ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
COMPLETION_WAITING_DOTS="true"
DEFAULT_USER="dan"
plugins=(vi-mode git git-extras zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

[ -f $HOME/.bash_aliases ] && source $HOME/.bash_aliases

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

delete-in() {
	local CHAR LCHAR RCHAR LSEARCH RSEARCH COUNT
	read -k CHAR
	if [ "$CHAR" = "w" ]; then
		zle vi-backward-word
		LSEARCH=$CURSOR
		zle vi-forward-word
		RSEARCH=$CURSOR
		RBUFFER="$BUFFER[$RSEARCH+1,${#BUFFER}]"
		LBUFFER="$LBUFFER[1,$LSEARCH]"
		return
	elif [ "$CHAR" = "(" ] || [ "$CHAR" = ")" ] || [ "$CHAR" = "b" ]; then
			LCHAR="("
			RCHAR=")"
	elif [ "$CHAR" = "[" ] || [ "$CHAR" = "]" ]; then
			LCHAR="["
			RCHAR="]"
	elif [ $CHAR = "{" ] || [ $CHAR = "}" ] || [ "$CHAR" = "B" ]; then
			LCHAR="{"
			RCHAR="}"
	else
			LCHAR="$CHAR"
			RCHAR="$CHAR"
	fi
	LSEARCH=${#LBUFFER}
	while [ "$LSEARCH" -gt 0 ] && [ "$LBUFFER[$LSEARCH]" != "$LCHAR" ]; do
			LSEARCH=$(expr $LSEARCH - 1)
	done
	if [ "$LBUFFER[$LSEARCH]" != "$LCHAR" ]; then
			return
	fi
	RSEARCH=0
	while [ "$RSEARCH" -lt $(expr ${#RBUFFER} + 1 ) ] && [ "$RBUFFER[$RSEARCH]" != "$RCHAR" ]; do
			RSEARCH=$(expr $RSEARCH + 1)
	done
	if [ "$RBUFFER[$RSEARCH]" != "$RCHAR" ]; then
			return
	fi
	RBUFFER="$RBUFFER[$RSEARCH,${#RBUFFER}]"
	LBUFFER="$LBUFFER[1,$LSEARCH]"
}
zle -N delete-in


change-in() {
        zle delete-in
        zle vi-insert
}
zle -N change-in

delete-around() {
        zle delete-in
        zle vi-backward-char
        zle vi-delete-char
        zle vi-delete-char
}
zle -N delete-around

change-around() {
        zle delete-in
        zle vi-backward-char
        zle vi-delete-char
        zle vi-delete-char
        zle vi-insert
}
zle -N change-around

bindkey -M vicmd "ca" change-around
bindkey -M vicmd "ci" change-in
bindkey -M vicmd "cc" vi-change-whole-line
bindkey -M vicmd "da" delete-around
bindkey -M vicmd "di" delete-in
bindkey -M vicmd "dd" kill-whole-line
