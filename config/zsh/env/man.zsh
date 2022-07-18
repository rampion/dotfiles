# When the shell is being run by vim's `:terminal` command, have the `man`
# command run `:Man` in the parent vim, rather than present the information at
# the terminal

if (( ${+VIM_SERVERNAME} )); then
  man() {
    if [[ $# == 1 ]] ; then
      command vim --servername $VIM_SERVERNAME --remote-send "<C-W>:Man $1<CR>";
    else
      1>&2 echo 'try `command man` instead';
      return 1
    fi
  }
fi
