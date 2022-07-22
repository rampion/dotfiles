# vim:set ft=zsh:
#
# $ZDOTDIR/env/options.zsh
#
# Sourced by zsh at startup via $ZDOTDIR/.zshenv. Use this file to configure
# options
#
# See zshoptions(1) for a list of the many options that can be used to tune the
# behaviour of the shell.  Some options that apply to interactive shells appear
# in $ZDOTDIR/options/interactive

# ------------------------------------------------------------------------------
#                             Expansion and Globbing
# ------------------------------------------------------------------------------

# Treat '#', '~', and '^' as patterns for filename generation
setopt EXTENDED_GLOB

# If a pattern has no matches, delete it from the argument list
setopt NULL_GLOB

# Treat unset parameters as an error, rather than an empty string
unsetopt UNSET

# ------------------------------------------------------------------------------
#                                  Shell State
# ------------------------------------------------------------------------------

# If the shell has not inherited an environment from another shell, force it to
# be a login shell so that we configure the environment.  The typical case
# where shell level is 1 and the shell is not already a login shell is the
# shell run by sshd(8) when running a remote command without logging in.  This
# requires that the login shell dot files (.zprofile and .zlogin) do not assume
# that the shell is interactive or has an attached terminal.
(( $SHLVL == 1 )) && setopt LOGIN
