export SSH_AUTH_SOCK=$HOME/.ssh/auth-sock
export SSH_AGENT_INFO=$HOME/.ssh/agent-info
export SSH_AGENT_PID="UNKNOWN"

# attempt to remember any existing ssh-agent settings
if [[ -f $SSH_AGENT_INFO ]]; then
  . $SSH_AGENT_INFO > /dev/null
fi

function auto-ssh-agent {
  # make sure ssh-agent is still alive
  if [[ -S $SSH_AUTH_SOCK ]] && [[ -f $SSH_AGENT_INFO ]] && $SSH_AGENT_PID > /dev/null; then
    echo Found ssh-agent with pid $SSH_AGENT_PID on socket $SSH_AUTH_SOCK
  else
    # clean up after dead ssh-agent
    if [[ -e $SSH_AUTH_SOCK ]]; then
      echo Removing dangling ssh-agent socket $SSH_AUTH_SOCK
      rm -f $SSH_AUTH_SOCK
    fi
    if [[ -f $SSH_AGENT_INFO ]]; then
      echo Removing outdated ssh-agent info $SSH_AGENT_INFO
      rm -f $SSH_AGENT_INFO
    fi
    if ps $SSH_AGENT_PID > /dev/null; then
      echo Killing old ssh-agent $SSH_AGENT_PID
      kill $SSH_AGENT_PID
    fi
    
    # start a new SSH agent
    echo Starting new ssh-agent on socket $SSH_AUTH_SOCK
    ssh-agent -P /opt/cspid/libcspid.so -a $SSH_AUTH_SOCK > $SSH_AGENT_INFO
    
    # get settings for new ssh agent
    if [[ -f $SSH_AGENT_INFO ]]; then
      . $SSH_AGENT_INFO > /dev/null
    fi
    
    # fail if unable to get new ssh-agent settings
    if [[ ! -S $SSH_AUTH_SOCK ]] ||
       [[ ! -f $SSH_AGENT_INFO ]] ||
       ! ps $SSH_AGENT_PID > /dev/null; then
      echo Failed to start ssh-agent, quitting
      exit - 1
    fi
    
    echo Run ssh-add to add identity to ssh agent
  fi
}
# vim: set filetype=zsh
