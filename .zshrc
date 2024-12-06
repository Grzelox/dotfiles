export PATH=/opt/homebrew/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="macovsky"
zstyle ':omz:update' mode auto     
zstyle ':omz:update' frequency 3
HIST_STAMPS="mm/dd/yyyy"

plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8


export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Shopify Hydrogen alias to local projects
alias h2='$(npm prefix -s)/node_modules/.bin/shopify hydrogen'
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
