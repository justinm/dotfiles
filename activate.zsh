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

ENABLE_JAVA="false"
ENABLE_NVM="false"

DOTFILE_PATH=$(dirname $0:A)

# Compilation flags
#export ARCHFLAGS="-arch x86_64"
export EDITOR='vim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

fpath+=$DOTFILE_PATH/completions

##################################

THEME="robbyrussell"

# powerlevel10k tab complete is odd in IntelliJ's terminal
#[[ "$__CFBundleIdentifier" != "com.jetbrains.intellij" ]] && [[ -f $DOTFILE_PATH/.p10k.zsh ]] && {
  THEME="romkatv/powerlevel10k"

  source $DOTFILE_PATH/.p10k.zsh
#}

# Antigen
##################################
source $DOTFILE_PATH/vendor/antigen.zsh

# Remove the user@computer from prompt
export DEFAULT_USER=$USER
HIST_STAMPS="yyyy/mm/dd"
COMPLETION_WAITING_DOTS="true"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

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
#antigen bundle joshskidmore/zsh-fzf-history-search
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme $THEME

[[ "$ENABLE_NVM" == "true" ]] && [[ -e "$HOME/.nvm" ]] && {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    antigen bundle nvm
}

# Tell Antigen that you're done.
antigen apply

export ZSH_EVALCACHE_DIR="$HOME/cache/eval-cache"

[[ "$ENABLE_JAVA" == "true" ]] && [[ -e "/usr/libexec/java_home" ]] && {
  JAVA_HOME=$(/usr/libexec/java_home)
  export JAVA_HOME
}

if [[ -e "$HOME/bin/rtx" ]]; then
  eval "$(~/bin/rtx activate zsh)"
fi

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
[[ -f $DOTFILE_PATH/tools/find.zsh ]] && . $DOTFILE_PATH/tools/find.zsh
[[ -f $DOTFILE_PATH/tools/mac.zsh ]] && . $DOTFILE_PATH/tools/mac.zsh
[[ -f $DOTFILE_PATH/tools/ssl.zsh ]] && . $DOTFILE_PATH/tools/ssl.zsh
[[ -f $DOTFILE_PATH/tools/web.zsh ]] && . $DOTFILE_PATH/tools/web.zsh

# Caching
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

setopt rm_star_silent

export KREW_ROOT=${KREW_ROOT:-$HOME/.krew}
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:${KREW_ROOT:-$HOME/.krew}/bin"
export PATH="$PATH:Applications/Postgres.app/Contents/Versions/latest/bin"
export PATH="$PATH:${KREW_ROOT}/bin"
export DOCKER_DEFAULT_PLATFORM="linux/amd64"
