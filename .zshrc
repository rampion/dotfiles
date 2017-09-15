# loaded by all shells, but not scripts

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

# if using tmux, let zsh tell tmux what the title and hardstatus
# of the tab window should be.
if ! [ -z $TMUX ]; then
	# use the current user as the prefix of the current tab title (since that's
	# fairly important, and I change it fairly often)
  TAB_TITLE_PREFIX='"${USER}:"'
	# when at the shell prompt, show a truncated version of the current path (with
	# standard ~ replacement) as the rest of the title.
	TAB_TITLE_PROMPT='`echo $PWD | sed "s/^\/Users\//~/;s/^~$USER/~/;s/\/..*\//\/...\//"`'
	# when running a command, show the title of the command as the rest of the
	# title (truncate to drop the path to the command)
	TAB_TITLE_EXEC='$cmd[1]:t'

	# use the current path (with standard ~ replacement) in square brackets as the
	# prefix of the tab window hardstatus.
	TAB_HARDSTATUS_PREFIX='"[`echo $PWD | sed "s/^\/Users\//~/;s/^~$USER/~/"`] "'
	# when at the shell prompt, use the shell name (truncated to remove the path to
	# the shell) as the rest of the title
	TAB_HARDSTATUS_PROMPT='$SHELL:t'
	# when running a command, show the command name and arguments as the rest of
	# the title
	TAB_HARDSTATUS_EXEC='$cmd'

	# tell tmux what the tab window title ($1) and the hardstatus($2) should be
  function tmux_set()
  {
		#	set the tab window title (%t) for tmux
		print -nR $'\033k'$1$'\033'\\\

		# set hardstatus of tab window (%h) for tmux
		print -nR $'\033]0;'$2$'\a'
  }
	# called by zsh before executing a command
  function preexec()
  {
		local -a cmd; cmd=(${(z)1}) # the command string
		eval "tab_title=$TAB_TITLE_PREFIX$TAB_TITLE_EXEC"
		eval "tab_hardstatus=$TAB_HARDSTATUS_PREFIX$TAB_HARDSTATUS_EXEC"
		tmux_set $tab_title $tab_hardstatus
  }
	# called by zsh before showing the prompt
  function precmd()
  {
		eval "tab_title=$TAB_TITLE_PREFIX$TAB_TITLE_PROMPT"
		eval "tab_hardstatus=$TAB_HARDSTATUS_PREFIX$TAB_HARDSTATUS_PROMPT"
		tmux_set $tab_title $tab_hardstatus
  }
fi

# make ESC-V bring up current line in EDITOR
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

source ~/.zshprompt
