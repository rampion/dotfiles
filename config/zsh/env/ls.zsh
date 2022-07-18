# set up `ls` for color on OSX
# code  foreground  background  type
#   gx   cyan        default     directory
#   fx   magenta     default     symbolic link
#   cx   green       default     socket
#   dx   brown       default     pipe
#   bx   red         defautl     executable
#   eg   blue        cyan        block special
#   ed   blue        brown       character special
#   ab   black       red         executable with setuid bit set
#   ag   black       cyan        executable with setgid bit set
#   ac   black       green       directory writable to others, with sticky bit
#   ad   black       brown       directory writable to others, without sticky bit
export CLICOLOR=1
export LSCOLORS="gxfxcxdxbxegedabagacad"

# set up `ls` for color on *nix
# TODO: migrate to dir_colors format / dircolors command
#
# change the directory color
#   (S)         - shortest match
#   di          - see `man dir_colors` DIRECTORY
#   38;2;       - use RGB foreground color
#   152;152;255 - #9898ff, light shade of blue-magenta
LS_COLORS=${(S)LS_COLORS/di=*:/di=38;2;152;152;255:}

# -F append indicator (*/=>@|)
# --color=auto - if output is a tty
alias ls = "ls -F --color=auto"
