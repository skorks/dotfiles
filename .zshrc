# Initialize Homebrew environment first (moved from .zprofile)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install Starship if not present
if ! command -v starship &> /dev/null; then
  echo "Installing Starship via Homebrew..."
  brew install starship
fi

# Initialize Starship
eval "$(starship init zsh)"

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33} %F{34}Installation successful.%f%b" || \
    print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load essential plugins (simplified syntax)
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# Load OMZ git plugin (much faster than full OMZ)
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit snippet OMZ::plugins/copyfile/copyfile.plugin.zsh
zinit snippet OMZ::plugins/copypath/copypath.plugin.zsh

# Essential zsh options
unsetopt correctall              # Disable annoying auto-correction
setopt AUTO_CD                   # cd by typing directory name
setopt HIST_VERIFY               # Show command before running history expansion
setopt SHARE_HISTORY             # Share history between sessions
setopt HIST_IGNORE_DUPS          # Don't record duplicate commands
setopt HIST_IGNORE_SPACE         # Don't record commands starting with space
setopt EXTENDED_GLOB             # Enable extended globbing patterns

# Cache brew --prefix for performance
if [[ -z "$BREW_PREFIX" ]]; then
  export BREW_PREFIX=$(brew --prefix)
fi

# Optimize PATH setup
PATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
PATH="$BREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"
PATH="$BREW_PREFIX/opt/curl/bin:$PATH"
PATH="/Users/askorkin/.local/bin:$PATH"

# Terminal colors and editor settings
export CLICOLOR=1
export LSCOLORS="ExFxCxDxBxegedabagacad"        # BSD ls colors (fallback)
export LS_COLORS="di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;34:ow=1;34"  # GNU ls colors
export EDITOR="code"
export VISUAL="code --wait"
export GIT_EDITOR="code --wait"

# Useful aliases
alias h='history'
alias j='jobs -l'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'

# Development shortcuts
alias be='bundle exec'
alias g='git'
alias code.='code .'

# Safe versions (don't override system commands)
alias duh='du -h'
alias dfh='df -h'

# Locale settings for proper Unicode support
export LANG="en_AU.UTF-8"
export LC_ALL="en_AU.UTF-8"

# Terminal title configuration for iTerm2
function set_terminal_title() {
  local current_path="$PWD"
  local home_path="$HOME"

  # Replace home directory with ~
  if [[ "$current_path" == "$home_path"* ]]; then
    current_path="~${current_path#$home_path}"
  fi

  # Truncate path if too long (keep last 3 directories)
  local truncated_path
  if [[ ${#current_path} -gt 40 ]]; then
    # Split path into components
    local path_parts=(${(s:/:)current_path})
    local num_parts=${#path_parts}

    if [[ $num_parts -gt 3 ]]; then
      truncated_path=".../${path_parts[-2]}/${path_parts[-1]}"
    else
      truncated_path="$current_path"
    fi
  else
    truncated_path="$current_path"
  fi

  echo -ne "\033]1;${truncated_path}\007"  # Tab title (truncated path)
  echo -ne "\033]2;$current_path\007"      # Window title (full path with ~)
}

# Update terminal title when changing directories
function chpwd() {
  set_terminal_title
}

# Update terminal title for each prompt (ensures it updates reliably)
precmd() {
  set_terminal_title
}

# Set initial terminal title
set_terminal_title

# NVM configuration (lazy load for faster startup)
export NVM_DIR="$HOME/.nvm"
if [[ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ]]; then
  # Create lazy loading function
  nvm() {
    unset -f nvm
    source "$BREW_PREFIX/opt/nvm/nvm.sh"
    [ -s "$BREW_PREFIX/opt/nvm/bash_completion" ] && source "$BREW_PREFIX/opt/nvm/bash_completion"
    nvm "$@"
  }

  # Create lazy loading for node and npm as well
  node() {
    unset -f node npm npx
    source "$BREW_PREFIX/opt/nvm/nvm.sh"
    node "$@"
  }

  npm() {
    unset -f node npm npx
    source "$BREW_PREFIX/opt/nvm/nvm.sh"
    npm "$@"
  }

  npx() {
    unset -f node npm npx
    source "$BREW_PREFIX/opt/nvm/nvm.sh"
    npx "$@"
  }
fi

# rbenv configuration (lazy load for faster startup)
if command -v rbenv &> /dev/null; then
  rbenv() {
    unset -f rbenv ruby gem bundle
    eval "$(rbenv init -)"
    rbenv "$@"
  }

  ruby() {
    unset -f rbenv ruby gem bundle
    eval "$(rbenv init -)"
    ruby "$@"
  }

  gem() {
    unset -f rbenv ruby gem bundle
    eval "$(rbenv init -)"
    gem "$@"
  }

  bundle() {
    unset -f rbenv ruby gem bundle
    eval "$(rbenv init -)"
    bundle "$@"
  }
fi
