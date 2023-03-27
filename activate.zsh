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

fpath+=$DOTFILE_PATH/completions

##################################

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
antigen bundle kiurchv/asdf.plugin.zsh
antigen bundle fzf
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
#export ARCHFLAGS="-arch x86_64"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export GOPATH=$HOME/.go

if [ -e /usr/libexec/java_home ]; then
	export JAVA_HOME=$(/usr/libexec/java_home)
fi

export KREW_ROOT=${KREW_ROOT:-$HOME/.krew}

if [[ -e "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    antigen bundle nvm
fi

if [[ -e "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]]; then
    . /opt/homebrew/opt/asdf/libexec/asdf.sh
fi

export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:${KREW_ROOT:-$HOME/.krew}/bin"
export PATH="$PATH:Applications/Postgres.app/Contents/Versions/latest/bin"
export PATH="$PATH:${KREW_ROOT}/bin"

if [[ $(/usr/bin/which lsd) != "" ]]; then
    alias ls=lsd
fi

if [[ $(/usr/bin/which saml2aws) != "" ]]; then
    eval "$(saml2aws --completion-script-zsh)"
fi

if [[ $(/usr/bin/which kubectl) != "" ]]; then
    source <(kubectl completion zsh)
fi

if [[ $(/usr/bin/which pyenv) != "" ]]; then
    eval "$(pyenv init --path)"
fi

[[ -f $HOME/.zsecrets ]] && source $HOME/.zsecrets
[[ -f $HOME/.zsh_profile ]] && source $HOME/.zsh_profile

# Tools
[[ ! -f $DOTFILE_PATH/tools/aws.zsh ]] || source $DOTFILE_PATH/tools/aws.zsh
[[ ! -f $DOTFILE_PATH/tools/mac.zsh ]] || source $DOTFILE_PATH/tools/mac.zsh
[[ ! -f $DOTFILE_PATH/tools/web.zsh ]] || source $DOTFILE_PATH/tools/web.zsh
