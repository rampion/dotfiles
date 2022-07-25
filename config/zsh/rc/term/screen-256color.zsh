################################################################################
# sourced by .zshrc                                                            #
# enable zsh to set the current tab title and tab hardstatus for tmux          #
# (defines precmd, preexec)                                                    #
################################################################################

# set name of tabs as name of running command for tmux
# uses 'eva' so variables can be re-evaluated

RELATIVE_PWD='echo $PWD | sed "s%^$HOME%~%"'
HOST_NAME=`hostname -s`

# use a truncated version of the path as a prefix to the tab title
export TAB_TITLE_PREFIX='"`'"$RELATIVE_PWD"'| sed "s%.*/%%"`"'
# when at the shell prompt, just show the directory
export TAB_TITLE_PROMPT="/"
# when running a command, show the title of the command as the rest of the
# title (truncate to drop the path to the command)
export TAB_TITLE_EXEC='" ➤ ${cmd[1]:t}"'

# use the current path (with standard ~ replacement) in square brackets as the
# prefix of the tab window hardstatus
export TAB_HARDSTATUS_PREFIX='"'$HOST_NAME':"''"`'"$RELATIVE_PWD"'` ➤ "'

# when at the shell prompt, use the shell name (truncated to remove the path
# to the shell) as the rest of the title
export TAB_HARDSTATUS_PROMPT='""'
# when runing a command, show the command name and arguments as the rest of
# the title
# XXX: doesn't update hardstatus line when the string between the escape
# sequences is too long (when the $cm string is too long)
export TAB_HARDSTATUS_EXEC='"${cmd[*]}"'

# tell tmux what the tab window title ($1) and the hardstatus ($2)
# should be (using escape sequences)
function tell_tmux {
  # set the tab window title (%t) for tmux
  print -nR $'\033k'$1$'\00'\\\
  
  # set the hardstatus of the tab window (%h) for tmux
  print -nR $'\033]0;'$2$'\a'
}

# called by zsh before prompty displayed
function precmd {
  eval "tab_title=$TAB_TITLE_PREFIX$TAB_TITLE_PROMPT"
  eval "tab_hardstatus=$TAB_HARDSTATUS_PREFIX$TAB_HARDSTATUS_PROMPT"
  tell_tmux $tab_title $tab_hardstatus
}

# called by zsh before command executed
function preexec {
  local -a cmd; cmd=(${(z)1})
  eval "tab_title=$TAB_TITLE_PREFIX$TAB_TITLE_EXEC"
  eval "tab_hardstatus=$TAB_HARDSTATUS_PREFIX$TAB_HARDSTATUS_EXEC"
  tell_tmux $tab_title $tab_hardstatus
}

# vim: set filetype=zsh
