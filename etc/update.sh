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

cp "$SCRIPTPATH/init.sh" "$HOME/.local/etc/" 2> /dev/null
cp "$SCRIPTPATH/config.sh" "$HOME/.local/etc/" 2> /dev/null
cp "$SCRIPTPATH/profile.sh" "$HOME/.local/etc/" 2> /dev/null



