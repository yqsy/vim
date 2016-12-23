#! /usr/bin/env python2
import sys
import time
import subprocess


#----------------------------------------------------------------------
# flow control
#----------------------------------------------------------------------
def flow_control(command, hz):
	import subprocess
	hz = (hz < 10) and 10 or hz
	p = subprocess.Popen(
			command, 
			shell = True, 
			stderr = subprocess.STDOUT,
			stdout = subprocess.PIPE)
	stdout = p.stdout
	count = 0
	ts = long(time.time() * 1000000)
	period = 1000000 / hz
	while True:
		text = stdout.readline()
		if text == '':
			break
		text = text.rstrip('\n\r')
		current = long(time.time() * 1000000)
		if current < ts:
			delta = (ts - current)
			time.sleep(delta * 0.001 * 0.001)
			ts += period
		if ts < current - 100000:
			ts = period + current
		sys.stdout.write(text + '\n')
		sys.stdout.flush()
	return 0

#----------------------------------------------------------------------
# main program
#----------------------------------------------------------------------
def main(args):
	args = [n for n in args]
	if len(args) < 3:
		print 'usage: %s HZ command'%args[0]
		return 1
	hz = int(args[1])
	flow_control(args[2], hz)
	return 0


#----------------------------------------------------------------------
# main program
#----------------------------------------------------------------------
if __name__ == '__main__':
	main(sys.argv)



