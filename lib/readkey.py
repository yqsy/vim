import sys
import termios

data = []
fd = sys.stdin.fileno()
old = termios.tcgetattr(fd)
new = termios.tcgetattr(fd)
new[3] = new[3] & ~termios.ECHO 
new[3] = new[3] & ~termios.ICANON
termios.tcsetattr(fd, termios.TCSANOW, new)

names = {
		27:'<ESC>',
		10:'<CR>',
		127:'<BS>',
}

index = 0
while 1:
	ch = sys.stdin.read(1)
	x = ord(ch)
	if x >= 32 and x < 127:
		print '[%2x]: %s'%(x, chr(x))
	elif x in names:
		print '[%2x]: %s'%(x, names[x])
	else:
		print '[%2x]: ?'%(x)
	index += 1
	if ch == '\n': break



termios.tcsetattr(fd, termios.TCSANOW, old)


