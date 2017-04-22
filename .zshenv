# loaded by all shells and scripts 
export PYTHON_ROOT=~/Library/Python/2.7
export GOPATH=~/Documents/Code/Go

export PATH=\
${HOME}/.cabal/bin:\
${HOME}/.local/bin:\
/usr/local/bin:\
$HOME/Library/Haskell/bin:\
$HOME/.cargo/bin:\
$PATH:\
$PYTHON_ROOT/bin:\
$HOME/.rvm/bin:\
/usr/local/opt/ruby/bin:\
/usr/local/share/npm/bin:\
/opt/local/bin:\
/usr/bin:\
$GOPATH/bin

export MANPATH=/opt/local/man/:$MANPATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export SHELL=/bin/zsh
export EDITOR=vim

# set up ls (see man ls)
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

# let escape sequences through in LESS
export LESS="-REX"
