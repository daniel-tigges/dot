# Daniel ZSH config

# Import colorscheme from wal
[ -f ~/.cache/wal/sequences ] && (cat ~/.cache/wal/sequences &)

export TERM="st-256color"
autoload -U colors && colors # enable colors
source ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme

# History Settings
HISTFILE=$XDG_CACHE_HOME/zsh/history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY # use shared history
setopt APPEND_HISTORY # append to history file
setopt INC_APPEND_HISTORY # append as command is typed
setopt HIST_EXPIRE_DUPS_FIRST # duplicates are removed first
setopt HIST_IGNORE_DUPS # do not store duplications
setopt HIST_FIND_NO_DUPS # ignore dups when searching
setopt HIST_REDUCE_BLANKS # remove blanks from history
bindkey '^R' history-incremental-pattern-search-backward # bind CTRL+R searching through history

# Command Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select  #change to menu driven autocomplete
zstyle ':completion:*' list-suffixes # enable partial completion
zstyle ':completion:*' expand prefix suffix # set partial completion rules
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # case-insentivity
setopt COMPLETE_ALIASES # activate autocomplete for command line switches
_comp_options+=(globdots) # Include hidden files.
zmodload zsh/complist # to make use of vim keys in tab menu possible

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Misc
setopt AUTO_CD # enable automatic cd into a directory
setopt CORRECT # enable automatic correction
setopt CORRECT_ALL # enable automatic correction
stty stop undef # disable CTRL+S to freeze terminal

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
