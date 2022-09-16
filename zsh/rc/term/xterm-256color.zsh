# settings when running on an xterm (or xterm-emulator)

# For documentation on setting operating system controls via `echo -ne # "\e]...\a"`, see
# https://ww.xfree86.org/4.8.0/ctlseqs.html and search for "Operating System Controls"
#
# set cursor color to green
echo -ne "\e]12;#08ffaa\a"

# set highlight color to purple (not supported by gnome-terminal/vte)
echo -ne "\e]18;purple\a"

# tell xterm/gnome-terminal to report focus events (for tmux to interpret)
# (not necessary? seems to work ok without it)
#echo -ne '\e[?1004h\r\e[K'
