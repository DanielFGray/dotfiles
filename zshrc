#!/usr/bin/env zsh

autoload -Uz promptinit && promptinit
autoload -Uz compinit && compinit
autoload -Uz colors && colors
autoload -Uz zmv
autoload -Uz surround

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILE="$HOME/.zsh_history"
HISTSIZE=999999999
HISTFILESIZE=999999999
SAVEHIST=$HISTSIZE
REPORTTIME=1

MODE_INDICATOR="%{$fg[red]%}%{$bg[red]%}  %{$reset_color%}"
VIRTUAL_ENV_DISABLE_PROMPT=1
ZPROMPT_DEFAULT_USER='dan'

ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd
ZSH_AUTOSUGGEST_USE_ASYNC=1
# YSU_HARDCORE=1

declare -A ZINIT
ZINIT[BIN_DIR]=~/.zsh/zinit
ZINIT[HOME_DIR]=~/.zsh/zinit
ZINIT[PLUGINS_DIR]=~/.zsh/plugins
ZINIT[SNIPPETS_DIR]=~/.zsh/snippets
ZINIT[COMPLETIONS_DIR]=~/.zsh/completions
ZINIT[ZCOMPDUMP_PATH]=~/.zsh/zcomp
[[ ! -d ${ZINIT[HOME_DIR]}/.git ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT[HOME_DIR]"
source "${ZINIT[HOME_DIR]}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


zinit light-mode for \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl

if has starship; then
  source <(starship init zsh)
else
  zinit ice depth"1"
  zinit light romkatv/powerlevel10k
fi

zinit wait'!' lucid for \
  OMZP::docker-compose
  # OMZP::vi-mode

zinit for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
  zdharma-continuum/fast-syntax-highlighting \
    blockf \
  zsh-users/zsh-completions \
    light-mode \
  zsh-users/zsh-autosuggestions \
    light-mode \
  hlissner/zsh-autopair \
    light-mode \
  MichaelAquilina/zsh-you-should-use \
    light-mode \
  Aloxaf/fzf-tab
  # marlonrichert/zsh-autocomplete \
  # softmoth/zsh-vim-mode \

if [[ -f /etc/debian_version ]]; then
  zinit wait"1" lucid from"gh-r" as"null" for \
    sbin"**/fd"        sharkdp/fd \
    sbin"**/bat"       sharkdp/bat \
    sbin"**/rg"        BurntSushi/ripgrep \
    sbin"**/delta"     dandavison/delta \
    sbin"**/lsd"       lsd-rs/lsd \
    sbin"**/jq"        jqlang/jq \
    sbin"**/yq"        mikefarah/yq \
    sbin"**/zoxide"    ajeetdsouza/zoxide

  # fzf - fuzzy finder with full installation
  zinit ice lucid \
    atclone"./install --all" \
    atpull"%atclone" \
    pick"shell/completion.zsh" \
    src"shell/key-bindings.zsh"
  zinit light junegunn/fzf

  zinit ice as"null" lucid if'[[ ! $(command -v nvim) ]]' \
    atclone"make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=$HOME/.local install" \
    atpull"%atclone"
  zinit light neovim/neovim
fi

if [[ -f $HOME/.bash_aliases ]]; then
  source $HOME/.bash_aliases
else
  print "${fg[red]}Error loading bash_aliases${reset_color}\n"
fi

if command -v fzf &> /dev/null; then
  [[ $(type historygrep) = *'alias'* ]] && unalias historygrep
  function historygrep {
    print -z $(fc -nl 1 | grep -v '^history' | fzf --reverse --tac +s -e --height=20% -q "$*")
  }
fi

[[ $(type cd) = *'shell function'* ]] && unfunction cd
chpwd() {
  emulate -L zsh
  lt
}

if has zoxide; then
  unalias zi
  eval "$(zoxide init zsh)"
  function z {
    if (( $# == 0 )); then
      __zoxide_zi
    else
      __zoxide_z "$@"
    fi
  }
  alias cd='z'
fi

ask() {
  echo -n "$* "
  read -r -k 1 ans
  echo
  [[ ${ans:u} = Y* ]]
}

alias zcp='noglob zmv -C '
alias zln='noglob zmv -L '
alias zmv='noglob zmv '

alias -g L='| less -R'
alias -g S='| sort'
alias -g SU='| sort -u'
alias -g SUC='| sort | uniq -c | sort -n'
alias -g V='| vim -'
alias -g DN='&> /dev/null'
alias -g F='| fzf -e -m'

has jq && {
  alias -s json='jq -C "."'
}

has x-pdf && {
  alias -s pdf=x-pdf
  alias -s epub=x-pdf
  alias -s jar='java -jar'
}

setopt append_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
setopt share_history

setopt extended_glob
setopt no_case_glob

setopt nomatch
setopt notify
setopt prompt_subst
setopt complete_in_word
setopt menu_complete

setopt autocd
setopt auto_pushd
setopt pushd_silent
setopt pushd_to_home
setopt pushd_minus
setopt pushd_ignore_dups

setopt no_flow_control
setopt interactivecomments

unsetopt beep

bindkey -v

bindkey '^ ' autosuggest-accept

bindkey -M vicmd "^[[1~"  beginning-of-line
bindkey -M vicmd "^[[4~"  end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[A" up-line-or-history
bindkey "^[[B" down-line-or-history
bindkey ' ' magic-space

autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
# bindkey -M visual S add-surround

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*' prompt '%e>'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion::*:(rm|vi):*' ignore-line true
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion::approximate*:*' prefix-needed false
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

export DISABLE_AUTO_TITLE=true

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Bun
export BUN_INSTALL="/home/dan/.bun"
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# bun completions
[ -s "/home/dan/.bun/_bun" ] && source "/home/dan/.bun/_bun"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
