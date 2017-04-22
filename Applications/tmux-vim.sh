#!/usr/bin/env zsh
set -e

open /Applications/Utilities/Terminal.app

if tmux select-window -t ':<tmux-vim>' >/dev/null 2>&1 ; then
  tmux select-pane -t ':<tmux-vim>.0' >/dev/null 2>&1
  tmux send-keys -t ':<tmux-vim>' "C-[" ":tabe ${(q)*}" Enter
else
  tmux new-window -n '<tmux-vim>' "vim ${(q)*}"
  tmux send-keys -t ':<tmux-vim>' "C-[" ":silent cd %:h" Enter
  tmux set-option -t ':<tmux-vim>' allow-rename off >/dev/null 2>&1
fi
