# .profile .zprofile
# loaded by interactive shells, but not non-interactive shells or scripts

# use `dotfiles` alias to manage all ~/.* files 
alias dotfiles='git --git-dir=$HOME/.files --work-tree=$HOME'

# make it easier to call scala
alias scala-rl=rlwrap scala-2.9 -Xnojline
alias scala=scala-2.9
alias scalac=scalac-2.9

# disable autocorrection in cabal, cabal-dev since dist/sdist is annoying
alias cabal="nocorrect cabal "
alias cabal-dev="nocorrect cabal-dev "

# safety aliases
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias clean="rm -f *~"

# use escape sequences in 'ri'
alias ri="ri -f ansi"
