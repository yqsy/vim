# Antigen home
ANTIGEN="$HOME/.local/zsh/antigen"

# Check and install antigen if not exist
if [ ! -d "$HOME/.local/zsh/antigen" ]; then
	echo "Installing antigen ..."
	[ ! -d "$HOME/.local" ] && mkdir -p "$HOME/.local" 2> /dev/null
	[ ! -d "$HOME/.local/zsh" ] && mkdir -p "$HOME/.local/zsh" 2> /dev/null
	[ ! -f "$HOME/.z" ] && touch "$HOME/.z"
	git clone https://github.com/zsh-users/antigen.git "$HOME/.local/zsh/antigen" 
	if [ ! -f "$ANTIGEN/antigen.zsh" ]; then
		echo "can not find antigen, check $0 please"
		exit
	fi
fi


# Initialize command prompt
export PS1="%n@%m:%~%# "

# Initialize antigen
source "$ANTIGEN/antigen.zsh"

# Initialize default bash/zsh settings
[ -f "$HOME/.local/etc/init.sh" ] && source "$HOME/.local/etc/init.sh"
[ -f "$HOME/.local/etc/config.zsh" ] && source "$HOME/.local/etc/config.zsh" 

# Initialize oh-my-zsh
antigen use oh-my-zsh


# default bundles
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle svn-fast-info
antigen bundle command-not-find

antigen bundle colorize
antigen bundle github
antigen bundle python
antigen bundle z

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

# Load the theme. (uncomment this line below to setup theme)
# antigen theme robbyrussell

# check local packages
[ -f "$HOME/.local/etc/local.zsh" ] && source "$HOME/.local/etc/local.zsh"


antigen apply



