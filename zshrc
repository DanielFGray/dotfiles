ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
COMPLETION_WAITING_DOTS="true"
DEFAULT_USER="dan"
plugins=(vi-mode git git-extras zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

[[ -f $HOME/.bash_aliases ]] && source $HOME/.bash_aliases

if command -v fzf &> /dev/null; then
	unalias historygrep
	function historygrep {
		print -z $(fc -nl 1 | grep -v 'history' | fzf +s -e -q "$*")
	}
	function fzcmd {
		print -z $(printf -rl $commands:t ${(k)functions} ${(k)aliases} | sort | uniq | fzf -e -q "$*")
	}

fi

autoload -U zmv

alias zcp='noglob zmv -C '
alias zln='noglob zmv -L '
alias zmv='noglob zmv '

alias -g L='| less'
alias -g S='| sort'
alias -g V='| vim -'
alias -g DN='&> /dev/null'

bindkey -v
bindkey '^[[A'  history-search-backward
bindkey '^[[B'  history-search-forward
bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history
bindkey '^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

zle -N fancy-ctrl-z
zle -N delete-in
zle -N change-in
zle -N delete-around
zle -N change-around

bindkey '^Z' fancy-ctrl-z
bindkey -M vicmd 'ca' change-around
bindkey -M vicmd 'ci' change-in
bindkey -M vicmd 'cc' vi-change-whole-line
bindkey -M vicmd 'da' delete-around
bindkey -M vicmd 'di' delete-in
bindkey -M vicmd 'dd' kill-whole-line

fancy-ctrl-z() {
	if [[ "$#BUFFER" == 0 ]]; then
		bg
		zle redisplay
	else
		zle push-input
	fi
}

delete-in() {
	local CHAR LCHAR RCHAR LSEARCH RSEARCH COUNT
	read -k CHAR
	if [[ "$CHAR" == 'w' ]]; then
		zle vi-backward-word
		LSEARCH=$CURSOR
		zle vi-forward-word
		RSEARCH=$CURSOR
		RBUFFER="$BUFFER[$RSEARCH + 1, ${#BUFFER}]"
		LBUFFER="$LBUFFER[1, $LSEARCH]"
		return
	elif [[ "$CHAR" == '(' ]] || [[ "$CHAR" == ')' ]] || [[ "$CHAR" == 'b' ]]; then
		LCHAR="("
		RCHAR=")"
	elif [[ "$CHAR" == '[' ]] || [[ "$CHAR" == ']' ]]; then
		LCHAR="["
		RCHAR="]"
	elif [[ $CHAR == '{' ]] || [[ $CHAR == '}' ]] || [[ "$CHAR" == 'B' ]]; then
		LCHAR='{'
		RCHAR='}'
	else
		LCHAR="$CHAR"
		RCHAR="$CHAR"
	fi
	LSEARCH=${#LBUFFER}
	while [[ "$LSEARCH" > 0 ]] && [[ "$LBUFFER[$LSEARCH]" != "$LCHAR" ]]; do
		LSEARCH=$(expr $LSEARCH - 1)
	done
	if [[ "$LBUFFER[$LSEARCH]" != "$LCHAR" ]]; then
		return
	fi
	RSEARCH=0
	while [[ "$RSEARCH" < $(expr ${#RBUFFER} + 1 ) ]] && [[ "$RBUFFER[$RSEARCH]" != "$RCHAR" ]]; do
		RSEARCH=$(expr $RSEARCH + 1)
	done
	if [[ "$RBUFFER[$RSEARCH]" != "$RCHAR" ]]; then
		return
	fi
	RBUFFER="$RBUFFER[$RSEARCH, ${#RBUFFER}]"
	LBUFFER="$LBUFFER[1, $LSEARCH]"
}

change-in() {
	zle delete-in
	zle vi-insert
}

delete-around() {
	zle delete-in
	zle vi-backward-char
	zle vi-delete-char
	zle vi-delete-char
}

change-around() {
	zle delete-in
	zle vi-backward-char
	zle vi-delete-char
	zle vi-delete-char
	zle vi-insert
}
