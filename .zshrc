# From `man zshall`:
#
#   Commands are first read from /etc/zshenv [...]
#
#   Commands are then read from $ZDOTDIR/.zshenv. If the shell is a login
#   shell, commands are read from /etc/zprofile and then $ZDOTDIR/.zprofile.
#   Then, if the shell is interactive, commands are read from /etc/zshrc and
#   then $ZDOTDIR/.zshrc. Finally, if the shell is a login shell, /etc/zlogin
#   and $ZDOTDIR/.zlogin are read.
#
# By default, tmux runs all shells as login shells, making zprofile/zlogin less
# useful for my needs.

# /etc/zprofile runs /usr/libexec/path_helper, which clobbers the PATH settings
# from ~/.zshenv, so they need to be fixed
. ~/.zshpath

# enable completion
autoload -U compinit
compinit

#use vi-style keybindings
bindkey -v

setopt autolist # list ambiguous tab-completions
compctl -c man # use commands as tab-completions for arguments to man
setopt correctall # correct spelling on commands (setopt correct) and arguments
setopt noclobber # don't overwrite existing files (use >! if you still want to)
setopt ignoreeof # don't close the shell on CTRL-D (end-of-file)

setopt appendhistory # have all simultaneous sessions append their history
setopt histignoredups # don't save current line if it's the same as the last one
setopt nohistbeep # don't beep when trying to access a non-existent history entry
# If a new command line being added to the history list duplicates an older one, the older com-
# mand is removed from the list (even if it is not the previous event).
setopt histignorealldups
# Remove  command  lines from the history list when the first character on the line is a space,
# or when one of the expanded aliases contains a  leading  space.	Only  normal  aliases  (not
# global or suffix aliases) have this behaviour.  Note that the command lingers in the internal
# history until the next command is entered before it vanishes, allowing you to  briefly  reuse
# or edit the line.  If you want to make it vanish right away without entering another command,
# type a space and press return.
setopt histignorespace
# Remove the history (fc -l) command from the history list when invoked.  Note that the command
# lingers  in the internal history until the next command is entered before it vanishes, allow-
# ing you to briefly reuse or edit the line.
setopt histnostore
# Remove superfluous blanks from each command line being added to the history list.
setopt histreduceblanks
# When writing out the history file, older commands that duplicate newer ones are omitted.
setopt histsavenodups
# Whenever the user enters a line with history expansion,  don't  execute  the  line  directly;
# instead, perform history expansion and reload the line into the editing buffer.
setopt histverify
# This  options works like APPEND_HISTORY except that new history lines are added to the $HIST-
# FILE incrementally (as soon as they are entered), rather than waiting until the shell  exits.
# The  file will still be periodically re-written to trim it when the number of lines grows 20%
setopt incappendhistory

# include aborted commands in history
function _add_aborted_commands_to_history(){
  if [[ -v ZLE_LINE_ABORTED ]]; then
    print -S "$ZLE_LINE_ABORTED"
    unset ZLE_LINE_ABORTED
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _add_aborted_commands_to_history

if [[ $USER != "root" ]]; then
  HISTFILE="$HOME/.zsh_history"
  HISTSIZE=9999
  SAVEHIST=9999
fi

# if using tmux, have zsh specify the name of the current tmux window and the
# title of the current tmux pane.
if ! [ -z $TMUX ]; then
  # TODO when switching to tmux-2.3+ use after-select-pane hook to update window name?
  # TODO set status line background color by git status?

  autoload -Uz add-zsh-hook

  # use the (abbreviated) current path as the tmux window name (#W)
  # when running a command or at the shell prompt
  function set-tmux-window-name(){
    print -n "\ek$(print -D $PWD | sed 's;/.*/;/.../;')\e\\"
  }
  add-zsh-hook preexec set-tmux-window-name
  add-zsh-hook precmd set-tmux-window-name

  # use the full current path and the shell name as the tmux pane title (#T)
  # at the shell prompt
  function set-tmux-pane-title-precmd(){
    print -n "\e]0;[$(print -D $PWD)] ${SHELL:t}\a"
  }
  add-zsh-hook precmd set-tmux-pane-title-precmd

  # use the full current path and command as the tmux pane title (#T)
  # when running a command
  function set-tmux-pane-title-preexec(){
		local -a cmd; cmd=(${(z)1}) # the command string
    print -n "\e]0;[$(print -D $PWD)] $cmd\a"
  }
  add-zsh-hook preexec set-tmux-pane-title-preexec
fi

# make ESC-V bring up current line in EDITOR
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

source ~/.zshprompt
