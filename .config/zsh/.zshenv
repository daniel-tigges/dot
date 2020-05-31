#!/bin/zsh

# Will be executed by all zsh shells (interactive and login).

# set to discard duplicates from path
typeset -U PATH path

# source profile containing all relevant environment variables
. $HOME/.profile
