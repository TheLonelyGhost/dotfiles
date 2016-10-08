if [ ! -z "$SSH_AGENT_PID" -a -z "$TMUX" ]; then
  kill $SSH_AGENT_PID
fi
