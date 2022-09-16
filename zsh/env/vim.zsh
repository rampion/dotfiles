# When the shell is being run by vim's `:terminal` command, have the `vim` 
# command open a sfile in a new split in the parent vim, rather than in
# a nested vim instance

if (( ${+VIM_SERVERNAME} )); then
  vim() {
    if [[ $# == 1 ]] ; then
      command vim --servername $VIM_SERVERNAME --remote-send "<C-W>:lcd $PWD | sp $1<CR>";
    else
      1>&2 echo 'try `command vim` instead';
      return 1;
    fi
  }
fi
