#! /bin/sh

export DEFAULT_CHEAT_DIR=~/.vim/vim/cheat
export GOPATH="$HOME/.local/go"

export PATH="/usr/local/app/node-v8.9.4-linux-x64/bin:$PATH"


gdbtool () { emacs --eval "(gdb \"gdb -i=mi $*\")"; }

