#! /bin/sh

export LANG=en_US.UTF-8
# export LANG=en_HK.UTF-8

export DEFAULT_CHEAT_DIR=~/.vim/vim/cheat
export GOPATH="$HOME/.local/go"
export PATH="$GOPATH/bin:$PATH"


gdbtool () { emacs --eval "(gdb \"gdb -i=mi $*\")"; }

