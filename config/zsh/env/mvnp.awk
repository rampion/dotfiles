# used in ~/.zsh/alias by mvnp

BEGIN {
  numColumns = ENVIRON["COLUMNS"]
  ansiEscape = "(\033\\[([[:digit:]]+(;[[:digit:]]+)*)?m)"
  column = "(" ansiEscape "?.)"
  
  tooManyColumns = "^" column "{" (numColumns + 1) "}"
  longestPrefix = "^" column "{" (numColumns - 1) "}" ansiEscape "*"
}

{ eol="\n" }

/^\[\033\[1;34mINFO\033\[m\]/ {
  # overprint this line when new content appears
  eol=""
  
  # trim this line if too wide
  if ($0 ~ tooManyColumns) {
    match($0, longestPrefix)
    $0 = substr($0, RSTART, RLENGTH) "\033[1;36m…\033[m"
  }
}

{
  # clear line previously printed here (if any)
  printf "\r%s\033[J%s", $0, eol
}

END {
  # clear and go back up a line if last printed line was INFO
  if (eol == "") {
    print "\r\033[J\033[F"
  }
}
