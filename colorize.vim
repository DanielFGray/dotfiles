" File: Colorize.vim
" Summary: Change background color when in insert mode
" Author: doug edmunds <being_doug@yahoo.com>
" Last Modified: 1 Aug 2001
" Version: 1.0
" 
" Description:
" If you are a newbie, you know that it takes a while to get used
" to being in insert mode / command mode.
" This script provides a great visual clue by changing the background
" color when you are in insert mode, and back again when you hit
" escape.
" It doesn't try to capture every possible way to get into insert mode,
" just the main ones (i, o, s, and a), but you can easily add 
" lines similar to these to capture other keystrokes 
" which put you into insert mode.
"
" If you don't like 'lightyellow', pick another color :)
"
" To Install:
" Add these lines to your _gvimrc file (located in the same dir as gvim)
"
" ======================
"the main keystrokes that put you into insert mode
noremap i :highlight Normal guibg=lightyellow<cr>i
noremap o :highlight Normal guibg=lightyellow<cr>o
noremap s :highlight Normal guibg=lightyellow<cr>s
noremap a :highlight Normal guibg=lightyellow<cr>a
noremap I :highlight Normal guibg=lightyellow<cr>I
noremap O :highlight Normal guibg=lightyellow<cr>O
noremap S :highlight Normal guibg=lightyellow<cr>S
noremap A :highlight Normal guibg=lightyellow<cr>A

"You need the next line to change the color back when you hit escape.
inoremap <Esc> <Esc>:highlight Normal guibg=Sys_Window<cr> 

"Note: the color "Sys_Window" works for Windows only. 
"If running linux, use white or lightgrey instead.

