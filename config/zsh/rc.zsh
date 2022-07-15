#
# $ZDOTDIR/.zshrc
#
# Sourced by zsh at startup when the shell is interactive.  Use this file to
# configure options, aliases, functions, completion, keybindings, prompts, etc.
#

# ------------------------------------------------------------------------------
#                                   Options
# ------------------------------------------------------------------------------
source $ZDOTDIR/rc/options.zsh

# ------------------------------------------------------------------------------
#                                 Parameters
# ------------------------------------------------------------------------------
source $ZDOTDIR/rc/history.zsh
source $ZDOTDIR/rc/time.zsh

# ------------------------------------------------------------------------------
#                            Aliases and Functions
# ------------------------------------------------------------------------------
# make cp/mv/rm a little safer
alias cp="nocorrect cp -i"
alias mv="nocorrect mv -i"
alias rm="nocorrect rm -i"

# use the shell builtin `which` instead of an alias for /usr/bin/which
unalias which &>/dev/null

# use emacs instead of `info` because it's prettier
info() {
  if [[ $# == 1 ]]; then
    emacs -nw --funcall 'info' --eval '(Info-goto-node "('"$1"')")';
  else
    command info "$@";
  fi
}

# disable run-help until using a higher version of zsh
if false; then
  # use the shell plugin `run-help` instead of `man` so I'll be redirected to help
  # for the zsh builtins when relevent; it'll default to man for everything else.
  unalias run-help 2> /dev/null
  autoload run-help
  alias man=run-help
fi

# ------------------------------------------------------------------------------
#                                 Key Bindings
# ------------------------------------------------------------------------------
# See zshzle(1) for help with the zsh command line editor.

# Uncomment one of the following to select the main keymap:
bindkey -v # vi-style keys
#bindkey -e # emacs-style keys

# use C-p/C-n to scroll through history without dropping into normal mode
bindkey "\C-p" history-search-backward
bindkey "\C-n" history-search-forward

# for some reason, I need to tell zsh how to interpret the keycodes for
# delete / home / end / page up / page down
#
# see zshwiki.org/home/zle/bindkeys
bindkey "\e[1~" beginning-of-line
bindkey "\e[2~" quoted-insert
bindkey "\e[3~" delete-char
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history

# use <Esc>v to edit current command in vim
autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd edit-command-line

# ------------------------------------------------------------------------------
#                                Completion
# ------------------------------------------------------------------------------
# See zshcompsys(1) for help with the completion system.

# which order to iterate through completions possibilities in
zstyle ':completion:*' file-sort modification

# Initialize the completion system.
autoload -U compinit
compinit

# Enable git commit auto-complete
autoload -U git-hash
zle -C git-hash-complete-word git-hash
zle -C git-hash-objects complete-word git-hash-objects

autoload -U bashcompinit
bashcompinit
source $ZDOTDIR/rc/git-completion.zsh

# ------------------------------------------------------------------------------
#                                   Prompts
# ------------------------------------------------------------------------------
# See zshmisc(1) for escape sequences that can be used to customize prompts.
# Set PS1 for your main left prompt and RPS1 for your right prompt
source $ZDOTDIR/rc/prompt.zsh

# ------------------------------------------------------------------------------
#                                   Terminal
# ------------------------------------------------------------------------------
# Tell tmux/xterm/etc the current name of the terminal
if [ -r $ZDOTDIR/rc/term/$TERM.zsh ] ; then
  source $ZDOTDIR/rc/term/$TERM.zsh
fi

# ------------------------------------------------------------------------------
#                                Miscellaneous
# ------------------------------------------------------------------------------
# If the shell is not a login shell, "refresh" loaded modules to redefine
# things like aliases that might be set in the module files and cannot be
# inherited from a login shell.
[[ -o LOGIN ]] || module refresh
