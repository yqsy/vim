FORTUNES=/usr/share/games/fortunes

if [ -x /usr/games/fortune ]; then
	if [ -f $FORTUNES/debian-hints ]; then echo ""; fortune debian-hints; fi
	# if [ -f $FORTUNES/linux ]; then echo ""; fortune linux; fi
	echo ""; fortune; echo ""
fi


