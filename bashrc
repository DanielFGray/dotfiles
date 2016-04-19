#!/usr/bin/env bash
case $- in
    *i*) ;;
      *) return;;
esac

HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth
shopt -s histappend
shopt -s histverify
shopt -s checkwinsize
shopt -s globstar
shopt -s extglob

[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
