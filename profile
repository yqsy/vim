# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
    fi
else
	if [ -f "$HOME/.local/etc/init.sh" ]; then
		. "$HOME/.local/etc/init.sh"
	fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# execute "~/.local/profile/*.sh"
if [ -d "$HOME/.local/etc/init" ]; then
	for f in $HOME/.local/etc/init/L*.sh ; do
		[ -f "$f" ] && . "$f"
	done
fi

# execute local profile if it exists
if [ -f "$HOME/.local/etc/login.sh" ]; then
	. "$HOME/.local/etc/login.sh"
fi


# remove duplicate path
if [ -n "$PATH" ]; then
  old_PATH=$PATH:; PATH=
  while [ -n "$old_PATH" ]; do
    x=${old_PATH%%:*}       # the first remaining entry
    case $PATH: in
      *:"$x":*) ;;         # already there
      *) PATH=$PATH:$x;;    # not there yet
    esac
    old_PATH=${old_PATH#*:}
  done
  PATH=${PATH#:}
  unset old_PATH x
fi


