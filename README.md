Tracking personal configuration ("dot-files").

Designed to be used with a bare git repository:

    $ git clone git@github.com:rampion/dotfiles.git --bare $HOME/.files
    $ alias dotfiles='git --git-dir=$HOME/.files --work-tree=$HOME'
