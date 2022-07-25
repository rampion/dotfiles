if [[ $USER != root ]]; then
  # file used to save history
  HISTFILE="$HOME/.zsh_history"
  
  # number of events in the internal history list
  HISTSIZE=9999
  
  # number of events saved to history file
  SAVEHIST=9999
fi
