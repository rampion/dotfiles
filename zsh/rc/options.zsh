# vim:set ft=zsh
#
# $ZDOTDIR/rc/options.zsh
#
# Sourced by zsh at startup when the shell is interactive via $ZDOTDIR/.zsh
# Use this file to configure options.
#
# See zshoptions(1) for a list of the many options that can be used to tune the
# behaviour of the shell. Some options that apply also non-interactive shells
# appear in $ZDOTDIR/options/non-interactive

# ------------------------------------------------------------------------------
#                                 Changing Directories
# ------------------------------------------------------------------------------

# Don't change directory if the command is just a directory name
unsetopt AUTO_CD

# Make cd push the old directory onto the directory stack
setopt AUTO_PUSHD

# Don't push multiple copies of the same directory onto the directory stack
setopt PUSHD_IGNORE_DUPS

# Do not print the directory stack after pushd or popd.
setopt PUSHD_SILENT

# ------------------------------------------------------------------------------
#                                   Completion
# ------------------------------------------------------------------------------

# Move the cursor to the end after completion
setopt ALWAYS_TO_END

# List the available completions
setopt AUTO_LIST

# If an environment variable is set to a path, then use that environment
# variable's name for `%~` in prompt expansion
#
#    $ setopt AUTO_NAME_DIRS
#    $ pwd
#    ~/path/to/current/dir
#    $ print -P '%~'
#    ~/path/to/current/dir
#    $ export FOOBAR=$(pwd)
#    $ print -P '%~'
#    ~FOOBAR
setopt AUTO_NAME_DIRS

# Remove trailing slashes on completion
setopt AUTO_REMOVE_SLASH

# Make aliases distinct commands for completion purposes
setopt COMPLETE_ALIASES

# When attempting to complete a glob, cycle through completions, rather than
# inserting all matches
setopt GLOB_COMPLETE

# If there's a single completion, insert it rather than list it
unsetopt LIST_AMBIGUOUS

# Don't beep when completion is ambiguous
unsetopt LIST_BEEP

# Print completion matches as compactly as possible
setopt LIST_PACKED

# ------------------------------------------------------------------------------
#                                    History
# ------------------------------------------------------------------------------

# Don't beep when trying to use a nonexistent history entry
unsetopt HIST_BEEP

# Remove duplicates when inserting a command into the history
setopt HIST_IGNORE_ALL_DUPS

# Remove commands from the history when the first line is a space
setopt HIST_IGNORE_SPACE

# Remove the history (fc -l) command from history
setopt HIST_NO_STORE

# Remove superfluous blanks before adding a command to the history
setopt HIST_REDUCE_BLANKS

# Remove older duplicates when writing the history file
setopt HIST_SAVE_NO_DUPS

# Perform history expansion and reload the line rather immediately
# executing
setopt HIST_VERIFY

# Add lines to the history file immediately, rather than at shell exit
setopt INC_APPEND_HISTORY

# ------------------------------------------------------------------------------
#                                  Input/Output
# ------------------------------------------------------------------------------

# Try to correct spelling of commands
setopt CORRECT

# Disable output flow control via ^S/^Q
unset FLOW_CONTROL

# Exit on end-of-file (Ctrl-D).
unsetopt IGNORE_EOF

# Allow '# comment' on command line
setopt INTERACTIVE_COMMENTS

# Perform a path search even on command names with slashes in them
setopt PATH_DIRS

# Allow the short forms of for, repeat, select, if, and function constructs.
setopt SHORT_LOOPS

# Do not allow '>' to overwrite an existing file or '>>' to create a file; use
# '>|' and '>>|' to override
unsetopt CLOBBER

# ------------------------------------------------------------------------------
#                                  Job Control
# ------------------------------------------------------------------------------

# Automatically send CONT signal to `disown`ed jobs
setopt AUTO_CONTINUE

# Treat single word simple commands without redirection as candidates for
# resumption of an existing job.
#
#   $ cat > example
#   one
#   two
#   ^Z
#   zsh: suspended  cat > example
#   $ cat example
#   one
#   two
#   $ cat
#   [1]  + continued  cat > example
#   three
#   four
#   ^D
#   $ cat example
#   one
#   two
#   $ cat
#   [1]  + continued  cat > example
#   three
#   four
#   ^D
#   $ cat example
#   one
#   two
#   three
#   four
setopt AUTO_RESUME

# Halt shell exit if backgrounded/suspended jobs exist
setopt CHECK_JOBS

# ------------------------------------------------------------------------------
#                                   Prompting
# ------------------------------------------------------------------------------

# Allow parameter expansion and process substitution in prompts.
setopt PROMPT_SUBST

# Don't remove old RPROMPTSs
unsetopt TRANSIENT_RPROMPT

# ------------------------------------------------------------------------------
#                             Scripts and Functions
# ------------------------------------------------------------------------------

# Output hexadecimal numbers as `0xFF` viced `16#FF`.
#
#   $ typeset -i 16 y
#   $ print $(([#8] x = 32, y = 32))
#   8#40
#   $ print $x $y
#   8#40 16#20
#   $ setopt cbases
#   $ print $x $y
#   8#40 0x20
setopt C_BASES
