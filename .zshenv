# loaded by all shells and scripts 
export PYTHON_ROOT=~/Library/Python/2.7
export GOPATH=~/Documents/Code/Go

# use `dotfiles` alias to manage all ~/.* files 
alias dotfiles='git --git-dir=$HOME/.files --work-tree=$HOME'

. $HOME/.zshpath

export MANPATH=/opt/local/man/:$MANPATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export SHELL=/bin/zsh
export EDITOR=vim

# set up ls (see man ls)
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

# let escape sequences through in LESS
export LESS="-REX"
