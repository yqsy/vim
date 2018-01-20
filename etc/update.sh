#! /bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")


if [ ! -d "$HOME/.local" ]; then
	mkdir -p "$HOME/.local" 2> /dev/null
fi

if [ ! -d "$HOME/.local/etc" ]; then
	mkdir -p "$HOME/.local/etc" 2> /dev/null
fi

if [ ! -d "$HOME/.local/bin" ]; then
	mkdir -p "$HOME/.local/bin" 2> /dev/null
fi

if [ ! -d "$HOME/.config" ]; then
	mkdir -p "$HOME/.config" 2> /dev/null
fi

if [ ! -d "$HOME/.config/fish" ]; then
	mkdir -; "$HOME/.config/fish" 2> /dev/null
fi


cp $SCRIPTPATH/*.sh "$HOME/.local/etc/" 
cp $SCRIPTPATH/*.conf "$HOME/.local/etc/" 
cp $SCRIPTPATH/*.fish "$HOME/.config/fish"

cp $SCRIPTPATH/../tools/bin/* "$HOME/.local/bin"



