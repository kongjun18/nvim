" Configuration of neovim-qt
" Last Change: 2022-02-13
" Author: Kong Jun <kongjun18@outlook.com>
" Github: https://github.com/kongjun18
" License: GPL-2.0

if exists('loaded_ginit_vim') || &cp || version < 700
    finish
endif
let loaded_ginit_vim = 1

:GuiFont! SauceCodePro Nerd Font:h12

" Disable gui tabline which is ugly
:GuiTabline 0

" Disable gui popup menu which is ugly
:GuiPopupmenu 0

" Maximize window
call GuiWindowMaximized(1)
