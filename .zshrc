ZSH="/home/dan/.oh-my-zsh"
ZSH_THEME="agnoster"
COMPLETION_WAITING_DOTS="true"
#DISABLE_LS_COLORS="true"
plugins=(git git-extras tmux zsh-syntax-highlighting vi-mode)
source $ZSH/oh-my-zsh.sh

# if [[ -d "$HOME/.local/bin" ]]; then; export PATH="$HOME/.local/bin:$PATH"
# elif [[ -d "$HOME/.local/bin" ]]; then; export PATH="$HOME/.local/bin:$PATH"
# fi

#export PAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export EDITOR="vim"

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

source /home/dan/dotfiles/.alias.sh
