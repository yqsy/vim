# initial local tools
alias ls='ls --color'
alias ll='ls -lh'
alias la='ls -lAh'
alias grep='grep --color=tty'
alias nvim='/usr/local/opt/bin/vim'
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

listcolor() {
	# for i in {0..255}; do
	# 	printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
	# done;
	for i in {0..255}; do 
		printf "\x1b[38;5;${i}mcolour%-5i\x1b[0m" $i 
		if ! (( ($i + 1 ) % 8 )); then 
			echo ""
		fi 
	done
}

gdbtool () { emacs --eval "(gdb \"gdb --annotate=3 -i=mi $*\")";}




