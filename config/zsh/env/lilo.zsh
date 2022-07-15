# Communicate with a backgrounded process line by line
#
# Assumes the background process produces exactly one output line per input
# line.
mklilo() {
  if [ -z "${1:-}" ]; then
    echo "Usage: mklilo <command>"
    return -1
  fi
  
  export LILO_DIR=$(mktemp -d ~/.lolo/${1}.XXXXXXXXXX)
  
  mkfifo $LILO_DIR/stdin $LILO_DIR/keep-alive $LILO_DIR/stdout
  
  # keep stdout/stdin from closing when we read/write individual lines
  ( exec 8<$LILO_DIR/stdout
  ; cat $LILO_DIR/keep-alive > $LILO_DIR/stdin
  ) >/dev/null &!
  
  ( stdbuf --output=L "$@" < $LILO_DIR/stdin > $LILO_DIR/stdout
  ; rm -rf $LILO_DIR
  ) >/dev/null &!
  
  echo $! > $LILO_DIR/pid
  echo $LILO_DIR
}

lilo() {
  if [ -d "$LILO_DIR" -a -r "$LILO_DIR/pid" ] && kill -0 $(cat $LILO_DIR/pid); then
    if [ $# -gt 0 ]; then echo "$@"; else read -re; fi > $LILO_DIR/stdin
    head -n 1 $LILO_DIR/stdout
  elif [ -n "$LILO_DIR" ] ; then
    echo "bad LILO_DIR: $LILO_DIR" 1>&2
  fi
}

rmlilo() {
  local lilo_dir=${1:-$LILO_DIR}
  if [ -d "$lilo_dir" ]; then
    if
      [ -r "$lilo_dir/pid" ] && {
        local lilo_pid=$(cat $lilo_dir/pid);
        kill -0 "$lilo_pid"
      }
    then
      # close stdin to cue the process to exit
      # (need to manually close stdin if lilo was never called)
      echo -n > $lilo_dir/stdin
      echo -n > $lilo_dir/keep-alive
      
      # wait for the process to exit on its own
      while kill -0 "$lilo_pid" 2> /dev/null; do
        sleep 0.5
      done
    fi
    
    rm -rf $lilo_dir
    if [ -n "${LILO_DIR+1}" ] && [ "$lilo_dir" = "$LILO_DIR" ]; then
      unset LILO_DIR
    fi
  fi
}

# Fun with zsh's coproc primitive
# ➤ popen awk 'BEGIN { print "-----BEFORE-----" } { a=$0; gsub(".","«"); print; print a; gsub(".","»"); print }
# ➤ pread
# ------BEFORE------
# ➤ pask one two three four
# ««««««««««««««««««
# one two three four
# »»»»»»»»»»»»»»»»»»
# ➤ pwrite
# five six seven
# ➤ preads
# ««««««««««««««
# five six seven
# »»»»»»»»»»»»»»
# ➤ pask
# eight
# «««««
# eight
# »»»»»
# ➤ pask nine ten eleven twelve thirteen fourteen
# ««««««««««««««««««««««««««««««««««««««««
# nine ten eleven twelve thirteen fourteen
# »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
# ➤ preads
# ➤ pclose
# -----AFTER------
# ➤
popen() {
  unsetopt monitor
  # use line buffering
  coproc stdbuf --output L "$@"
  setopt monitor
}

pread() {
  read -pert
}

prwrite() {
  read -er >&p
}

pprint() {
  print -p "$@"
}

preads() {
  while pread ; do ; done
}

pask() {
  if [ $# -gt 0 ]; then
    pprint "$@"
  else
    pwrite
  fi
  preads
}

pclose() {
  unsetopt monitor
  # copy the coprocess's file descriptors so we can clean up reasonably
  exec {pin}>&p {pout}<&p
  # start a new coprocess to close <&p and >&p (ugly, but the only way)
  coproc :
  # close the coprocess's input and print its remaining output
  exec {pin}>&-
  cat <&$pout
  exec {pout}<&-
  setopt monitor
}
