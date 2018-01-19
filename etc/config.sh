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


#----------------------------------------------------------------------
# quick functions
#----------------------------------------------------------------------
gdbtool () { emacs --eval "(gdb \"gdb --annotate=3 -i=mi $*\")";}



#----------------------------------------------------------------------
# color man
#----------------------------------------------------------------------
if [[ "$TERM" =~ "xterm" ]]; then
	export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
	export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
	export LESS_TERMCAP_me=$(tput sgr0)
	export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
	export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
	export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
	export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
	export LESS_TERMCAP_mr=$(tput rev)
	export LESS_TERMCAP_mh=$(tput dim)
	export LESS_TERMCAP_ZN=$(tput ssubm)
	export LESS_TERMCAP_ZV=$(tput rsubm)
	export LESS_TERMCAP_ZO=$(tput ssupm)
	export LESS_TERMCAP_ZW=$(tput rsupm)
	export GROFF_NO_SGR=1         # For Konsole and Gnome-terminal
fi

# export MANWIDTH=80


