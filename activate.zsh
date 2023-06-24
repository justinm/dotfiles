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

ENABLE_ANTIGEN=true

if [[ $__INTELLIJ_COMMAND_HISTFILE__ ]]; then
  # Remove the user@computer from prompt
  export DEFAULT_USER=$USER
  THEME="robbyrussell"
else
  THEME=romkatv/powerlevel10k
fi

DOTFILE_PATH=$(dirname $0:A)

# Compilation flags
export EDITOR='vim'
#export ARCHFLAGS="-arch x86_64"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

fpath+=$DOTFILE_PATH/completions

##################################

if [[ "$ENABLE_ANTIGEN" == "true" ]]; then
    HIST_STAMPS="yyyy/mm/dd"
    COMPLETION_WAITING_DOTS="true"

    source $DOTFILE_PATH/vendor/antigen.zsh

    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ "$THEME" == "romkatv/powerlevel10k" ]] && [[ -f $DOTFILE_PATH/.p10k.zsh ]] && source $DOTFILE_PATH/.p10k.zsh

    antigen use oh-my-zsh

    antigen bundle aws
    antigen bundle brew
    antigen bundle brew-cask
    antigen bundle command-not-found
    antigen bundle git
    antigen bundle pip
    antigen bundle fzf
    antigen bundle mroth/evalcache
    antigen bundle reegnz/jq-zsh-plugin
    antigen bundle joshskidmore/zsh-fzf-history-search  
    antigen bundle zsh-users/zsh-autosuggestions
    antigen bundle zsh-users/zsh-completions
    antigen bundle zsh-users/zsh-history-substring-search
    antigen bundle zsh-users/zsh-syntax-highlighting

    # Load the theme.
    if [[ ! -z "$THEME" ]] && antigen theme $THEME
fi

export ZSH_EVALCACHE_DIR="$HOME/.zsh/cache"
export KREW_ROOT=${KREW_ROOT:-$HOME/.krew}
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:${KREW_ROOT:-$HOME/.krew}/bin"
export PATH="$PATH:Applications/Postgres.app/Contents/Versions/latest/bin"
export PATH="$PATH:${KREW_ROOT}/bin"

if [[ -e "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    [[ "$ENABLE_ANTIGEN" == "true" ]] && antigen bundle nvm
fi

# Tell Antigen that you're done.
[[ "$ENABLE_ANTIGEN" == "true" ]] && antigen apply

export KREW_ROOT=${KREW_ROOT:-$HOME/.krew}
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:${KREW_ROOT:-$HOME/.krew}/bin"
export PATH="$PATH:Applications/Postgres.app/Contents/Versions/latest/bin"
export PATH="$PATH:${KREW_ROOT}/bin"

# if [ -e /usr/libexec/java_home ]; then
# 	_evalcache export JAVA_HOME=$(/usr/libexec/java_home)
# fi

if [[ -e "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]]; then
    . /opt/homebrew/opt/asdf/libexec/asdf.sh
fi

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
[[ -f $DOTFILE_PATH/tools/aws.zsh ]] && . $DOTFILE_PATH/tools/aws.zsh
[[ -f $DOTFILE_PATH/tools/mac.zsh ]] && . $DOTFILE_PATH/tools/mac.zsh
[[ -f $DOTFILE_PATH/tools/ssl.zsh ]] && . $DOTFILE_PATH/tools/ssl.zsh
[[ -f $DOTFILE_PATH/tools/web.zsh ]] && . $DOTFILE_PATH/tools/web.zsh

# Caching
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

setopt rm_star_silent
