# grab the current login's GNOME environment settings
alias update-environment=". <(tmux show-environment | grep -vE '^-')"
