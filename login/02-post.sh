FORTUNE=/usr/games/fortune
FORTUNES=/usr/share/games/fortunes

if [ -x $FORTUNE ]; then
	if [ -f $FORTUNES/debian-hints ]; then echo ""; $FORTUNE debian-hints; fi
	if [ -f $FORTUNES/wisdom ]; then echo ""; $FORTUNE wisdom; fi
	# if [ -f $FORTUNES/linux ]; then echo ""; fortune linux; fi
	echo ""
fi



