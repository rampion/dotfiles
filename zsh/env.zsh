#
# $ZDOTDIR/.zshenv
# 
# This file is always sourced by zsh at startup, unless the shell is started
# with the `-f` (NO_RCS) flag. Use this file for configuration that should be
# done in *every* shell, including non-interactive non-login shells.
#
# -----------------------------------------------------------------------------
#                                    Options
# -----------------------------------------------------------------------------
source $ZDOTDIR/env/options.zsh

# -----------------------------------------------------------------------------
#                                      Path
# -----------------------------------------------------------------------------
# let home.nix manage this

# -----------------------------------------------------------------------------
#                    Command-specific aliases and parameters
# -----------------------------------------------------------------------------
source $ZDOTDIR/env/ls.zsh
source $ZDOTDIR/env/less.zsh
source $ZDOTDIR/env/jq.zsh
source $ZDOTDIR/env/mvn.zsh
source $ZDOTDIR/env/python.zsh
source $ZDOTDIR/env/nix.zsh

# -----------------------------------------------------------------------------
#                                    Terminal
# -----------------------------------------------------------------------------
# Tell tmux/xterm/etc the current name of the terminal
if [ -r $ZDOTDIR/env/term/$TERM.zsh ] ; then
  source $ZDOTDIR/env/term/$TERM.zsh
fi

# -----------------------------------------------------------------------------
#                    Miscellaneous aliases and parameters
# -----------------------------------------------------------------------------

# use the wrapping vim instance when being run by vim's `:terminal` command
source $ZDOTDIR/env/vim.zsh
source $ZDOTDIR/env/man.zsh

# -----------------------------------------------------------------------------
#                    Miscellaneous parameters
# -----------------------------------------------------------------------------

# Use eastern time
export TZ=EST5EDT

# Let subprocesses detect the terminal width
export COLUMNS

# editor of choice... though I'm not sure when it's used
export ZSHEDIT=vim

export EDITOR=vim

export PAGER=less

export COOKIE_PATH=~/Private/cookies

# what command to use when redirection is used without a command
READNULLCMD=less

# don't report any login/logout events
watch=none

# vim: set filetype=zsh :
