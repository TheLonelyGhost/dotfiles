if [ ! -z "$SSH_AGENT_PID" -a -z "$TMUX" -a -z "${SSH_CONNECTION:-}" ]; then
  kill "$SSH_AGENT_PID"
fi
