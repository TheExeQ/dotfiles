# ~/.zshrc
# Based of dreamsofautonomy/zensh

export PATH="/Users/$USER/.local/bin:$PATH"

[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh

if [[ -f "/opt/homebrew/bin/brew" ]]; then
  # If you're using macos, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname "$ZINIT_HOME")"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey '^F' autosuggest-accept

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Shell integrations
eval "$(starship init zsh)"

# Display fancy computer info
fastfetch
