[ ! -d "$HOME/.local" ] && mkdir -p "$HOME/.local" 2> /dev/null
[ ! -d "$HOME/.local/zsh" ] && mkdir -p "$HOME/.local/zsh" 2> /dev/null


if [ ! -d "$HOME/.local/zsh/antigen" ]; then
	echo "Installing antigen ..."
	git clone https://github.com/zsh-users/antigen.git "$HOME/.local/zsh/antigen" 
fi

ANTIGEN="$HOME/.local/zsh/antigen"

if [ ! -d "$ANTIGEN" ]; then
	echo "can not install antigen, check $0 please"
	exit
fi

if [ ! -f "$ANTIGEN/antigen.zsh" ]; then
	echo "can not find antigen, check $0 please"
	exit
fi

if [ ! -f "$HOME/.local/etc/init.sh" ]; then
	echo "can not find ~/.local/etc/init.sh, check $0 please"
	exit
fi

source "$ANTIGEN/antigen.zsh"
[ -f "$HOME/.local/etc/init.sh" ] && source "$HOME/.local/etc/init.sh"
[ -f "$HOME/.local/etc/config.zsh" ] && source "$HOME/.local/etc/config.zsh" 

export PS1="$ "

antigen use oh-my-zsh

[ -f "$HOME/.local/etc/bundle.zsh" ] && source "$HOME/.local/etc/bundle.zsh"
[ -f "$HOME/.local/etc/local.zsh" ] && source "$HOME/.local/etc/local.zsh"

antigen apply



