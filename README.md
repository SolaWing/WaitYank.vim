# WaitYank.vim

When you type at insert mode, did you ever yank text at other place, and paste at current position?

Normally you need to type `<ESC>` to back normal mode, then go to yank the wanted text, then press `g;pa` to jump back,
paste and reenter the insert mode.

This pattern is so common to me. so I have created this plugin. With this plugin, you map a expr key to `WaitYank#Paste`, then when you yank, vim
will auto jump back, paste and reenter insert, save the 4 `g;pa` key and keep you focusing on input.
