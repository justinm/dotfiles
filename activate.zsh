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

ENABLE_JAVA="${ENABLE_JAVA:=false}"
ENABLE_NVM="${ENABLE_NVM:=false}"
ENABLE_ANTIGEN="${ENABLE_ANTIGEN:=false}"
ENABLE_ANTIDOTE="${ENABLE_ANTIDOTE:=true}"
ENABLE_THEMES="${ENABLE_THEMES:=true}"

DOTFILE_PATH=$(dirname $0:A)

# Compilation flags
#export ARCHFLAGS="-arch x86_64"
export EDITOR='vim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

autoload -Uz compinit
compinit

fpath+=$DOTFILE_PATH/completions

##################################

export DEFAULT_USER=$USER
HIST_STAMPS="yyyy/mm/dd"
COMPLETION_WAITING_DOTS="true"

[[ "$ENABLE_THEMES" == "true" ]] && {
  export ZSH_THEME="robbyrussell"

  [[ ! -e "$HOME/.p10k.zsh" ]] && {
    ln -s $DOTFILE_PATH/.p10k.zsh $HOME/.p10k.zsh
  }

  # powerlevel10k tab complete is odd in IntelliJ's terminal
  [[ "$__CFBundleIdentifier" != "com.jetbrains.intellij" ]] && [[ -e "$DOTFILE_PATH/.p10k.zsh" ]] && {
    export ZSH_THEME="romkatv/powerlevel10k"
  }
}

[[ "$ENABLE_ANTIDOTE" == "true" ]] && {
  [[ ! -d "${ZDOTDIR:-$HOME}/.antidote" ]] && {
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-$HOME}/.antidote
  }

  source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
  antidote load $DOTFILE_PATH/zsh_plugins.txt
}

[[ "$ENABLE_ANTIGEN" == "true" ]] && {
  # Antigen
  ##################################
  source $DOTFILE_PATH/vendor/antigen.zsh

    # Remove the user@computer from prompt
    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

  antigen use oh-my-zsh

  antigen bundle aws
  antigen bundle gitfast
  antigen bundle safe-paste
  antigen bundle joshskidmore/zsh-fzf-history-search
  antigen bundle zsh-users/zsh-autosuggestions
  antigen bundle zsh-users/zsh-completions
  antigen bundle zsh-users/zsh-syntax-highlighting

  [[ "$ENABLE_THEMES" == "true" ]] && [[ -n "$ZSH_THEME" ]] && antigen theme $ZSH_THEME
}

[[ "$ENABLE_NVM" == "true" ]] && [[ -e "$HOME/.nvm" ]] && {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

# Tell Antigen that you're done.
[[ "$ENABLE_ANTIGEN" == "true" ]] && antigen apply

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

if type lsd &>/dev/null
then
  alias ls=lsd
fi

if type kubectl &>/dev/null
then
  source <(kubectl completion zsh)
fi

# if type saml2aws &>/dev/null
# then
#   eval "$(saml2aws --completion-script-zsh)"
# fi

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

[[ -f $HOME/.zsecrets ]] && source $HOME/.zsecrets
[[ -f $HOME/.zsh_profile ]] && source $HOME/.zsh_profile

# Tools
[[ -f $DOTFILE_PATH/tools/aws.zsh ]] && . $DOTFILE_PATH/tools/aws.zsh
[[ -f $DOTFILE_PATH/tools/find.zsh ]] && . $DOTFILE_PATH/tools/find.zsh
[[ -f $DOTFILE_PATH/tools/mac.zsh ]] && . $DOTFILE_PATH/tools/mac.zsh
[[ -f $DOTFILE_PATH/tools/python.zsh ]] && . $DOTFILE_PATH/tools/python.zsh
[[ -f $DOTFILE_PATH/tools/ssl.zsh ]] && . $DOTFILE_PATH/tools/ssl.zsh
[[ -f $DOTFILE_PATH/tools/web.zsh ]] && . $DOTFILE_PATH/tools/web.zsh

# Caching
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':omz:alpha:lib:git' async-prompt yes

# Make git completion more resilient
zstyle ':completion:*:git-*:*' force-list always
zstyle ':completion:*:git-*:*' complete-options true
# Reduce git completion cache time
zstyle ':completion:*:git-*:*' cache-ttl 300

setopt rm_star_silent

bindkey "^[f" forward-word  # Option + Right Arrow
bindkey "^[b" backward-word # Option + Left Arrow
bindkey "^[[H" beginning-of-line # Home
bindkey "^[[F" end-of-line # End

alias ls="ls --color=auto"
alias ll="ls -al --color=auto"

export KREW_ROOT=${KREW_ROOT:-$HOME/.krew}
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:${KREW_ROOT:-$HOME/.krew}/bin"
export PATH="$PATH:Applications/Postgres.app/Contents/Versions/latest/bin"
export PATH="$PATH:${KREW_ROOT}/bin"
export PATH="$PATH:$HOME/.docker/bin"
export PATH="$PATH:$HOME/bin"
export DOCKER_DEFAULT_PLATFORM="linux/amd64"

if [[ -e "/usr/local/bin/starship" ]] && [[ "$ENABLE_STARSHIP" == "true" ]]; then
    export STARSHIP_CONFIG="$DOTFILE_PATH/starship.toml"
    eval "$(starship init zsh)"
fi
