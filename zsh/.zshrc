export PATH=/opt/homebrew/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export PATH="./nvim-macos-arm64/bin:$PATH"

ZSH_THEME="kanagawa"
zstyle ':omz:update' mode auto     
zstyle ':omz:update' frequency 3
HIST_STAMPS="mm/dd/yyyy"

plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh


# Created by `pipx` on 2025-12-12 20:18:49
export PATH="$PATH:/Users/grzelo/.local/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/grzelo/.lmstudio/bin"
# End of LM Studio CLI section


# Entire CLI shell completion
autoload -Uz compinit && compinit && source <(entire completion zsh)

# bun completions
[ -s "/Users/grzelo/.bun/_bun" ] && source "/Users/grzelo/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode
export PATH=/Users/grzelo/.opencode/bin:$PATH
