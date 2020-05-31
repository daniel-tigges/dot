# Daniel ZSH config

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


# Prompt Settings



# Command Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select  #change to menu driven autocomplete
zstyle ':completion:*' list-suffixes # enable partial completion
zstyle ':completion:*' expand prefix suffix # set partial completion rules
setopt COMPLETE_ALIASES # activate autocomplete for command line switches



# Misc
autoload -U colors && colors # enable colors
setopt AUTO_CD # enable automatic cd into a directory
setopt CORRECT # enable automatic correction
setopt CORRECT_ALL # enable automatic correction
stty stop undef # disable CTRL+S to freeze terminal
