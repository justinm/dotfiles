# Requirements
# brew install fzf

# Optional
# brew install lsd

######### CONFIGURATION ##########

# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"

# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# zstyle ':omz:update' frequency 30

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

DOTFILE_PATH=$(dirname $0:A)

HIST_STAMPS="yyyy/mm/dd"
COMPLETION_WAITING_DOTS="true"

##################################

if [[ $(/usr/bin/env lsd) != "" ]]; then
    alias ls=lsd
fi

source $DOTFILE_PATH/antigen.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $DOTFILE_PATH/.p10k.zsh ]] || source $DOTFILE_PATH/.p10k.zsh

antigen use oh-my-zsh

antigen bundle aws
antigen bundle brew
antigen bundle brew-cask
antigen bundle command-not-found
antigen bundle git
antigen bundle pip
antigen bundle nvm
antigen bundle reegnz/jq-zsh-plugin
antigen bundle joshskidmore/zsh-fzf-history-search  
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done.
antigen apply

# Compilation flags
export EDITOR='vim'
export ARCHFLAGS="-arch x86_64"
export LANG=en_US.UTF-8
