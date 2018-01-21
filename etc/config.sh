# initial local tools
alias ls='ls --color'
alias ll='ls -lh'
alias la='ls -lAh'
alias grep='grep --color=tty'
alias nvim='/usr/local/opt/bin/vim --cmd "let g:vim_startup=\"nvim\""'
alias mvim='/usr/local/opt/bin/vim --cmd "let g:vim_startup=\"mvim\""'
# alias tmux='tmux -2'

# term color
export TERM=xterm-256color


# setup for go if it exists
if [ -d "$HOME/.local/go" ]; then
	export GOPATH="$HOME/.local/go"
	if [ -d "$HOME/.local/go/bin" ]; then
		export PATH="$HOME/.local/go/bin:$PATH"
	fi
fi

# setup for go if it exists
if [ -d /usr/local/app/go ]; then
	export GOROOT="/usr/local/app/go"
	export PATH="/usr/local/app/go/bin:$PATH"
fi

# setup for nodejs
if [ -d /usr/local/app/node ]; then
	export PATH="/usr/local/app/node/bin:$PATH"
fi

# setup for cheat
if [ -d "$HOME/.vim/vim/cheat" ]; then
	export DEFAULT_CHEAT_DIR=~/.vim/vim/cheat
fi

# load z.sh
if [ -n "$BASH_VERSION" ]; then
	LOCAL="$HOME/.local"
	[ ! -d "$LOCAL" ] && mkdir -p "$LOCAL" > /dev/null 2>&1
	[ ! -d "$LOCAL/var" ] && mkdir -p "$LOCAL/var" > /dev/null 2>&1
	_Z_DATA="$LOCAL/var/z"
	[ -f "$HOME/.local/etc/z.sh" ] && . "$HOME/.local/etc/z.sh"
fi


#----------------------------------------------------------------------
# keymap
#----------------------------------------------------------------------
if [ -n "$ZSH_VERSION" ]; then
	bindkey -s '\e;' 'll\n'
fi


#----------------------------------------------------------------------
# quick functions
#----------------------------------------------------------------------
gdbtool () { emacs --eval "(gdb \"gdb --annotate=3 -i=mi $*\")";}




