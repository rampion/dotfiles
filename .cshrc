# @(#)Cshrc 1.6 91/09/05 SMI
#################################################################
#
#         .cshrc file
#
#         initial setup file for both interactive and noninteractive
#         C-Shells
#
#################################################################


# Set openwin as my default window system 
set mychoice=openwin

#         set up search path

# add directories for local commands
set lpath = ( )
if ( ${?mychoice} != 0 ) then
	if ( ${mychoice} == "openwin" ) then
		set lpath = ( /usr/openwin/bin/xview /usr/openwin/bin $lpath )
	endif
endif

set path = (. ~ $lpath ~/bin /bin /usr/local /usr/local/infosys.www/netscape /usr/ucb /usr/bin /usr/etc /usr/local/frame/bin /usr/local/bin )

#         cd path

#set lcd = ( )  #  add parents of frequently used directories
#set cdpath = (.. ~ ~/bin ~/src $lcd)

#         set this for all shells

set noclobber

#         aliases for all shells

alias cd            'cd \!*;echo $cwd'
alias cp            'cp -i'
alias mv            'mv -i'
alias rm            'rm -i'
alias pwd           'echo $cwd'
#alias del          'rm -i'
alias te	    'textedit \!* &'
#umask 002

#         skip remaining setup if not an interactive shell

if ($?USER == 0 || $?prompt == 0) exit

#          settings  for interactive shells

set history=40
set ignoreeof
setenv NNTPSERVER alnews.ncsc.mil
setenv FM_HOME /usr/local/frame/bin
stty erase ^H
if ( -f ~/.cshrc.personal) source ~/.cshrc.personal
