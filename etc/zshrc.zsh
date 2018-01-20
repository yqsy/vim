# Antigen home
ANTIGEN="$HOME/.local/bin/antigen.zsh"

# Check and install antigen if not exist
if [ ! -f "$ANTIGEN" ]; then
	echo "Installing antigen ..."
	[ ! -d "$HOME/.local" ] && mkdir -p "$HOME/.local" 2> /dev/null
	[ ! -d "$HOME/.local/bin" ] && mkdir -p "$HOME/.local/bin" 2> /dev/null
	[ ! -f "$HOME/.z" ] && touch "$HOME/.z"
	URL="http://git.io/antigen"
	TMPFILE="/tmp/antigen.zsh"
	if [ -x "$(which wget)" ]; then
		wget "$URL" -O "$TMPFILE" 
	else
		curl -L "$URL" -o "$TMPFILE" 
	fi
	if [ ! $? -eq 0 ]; then
		echo ""
		echo "ERROR: downloading antigen.zsh ($URL) failed !!"
		exit
	fi;
	echo "move $TMPFILE to $ANTIGEN"
	mv "$TMPFILE" "$ANTIGEN"
fi


# Initialize command prompt
export PS1="%n@%m:%~%# "

# Initialize antigen
source "$ANTIGEN"

# Initialize local bash/zsh settings
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


