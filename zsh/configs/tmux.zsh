
# =====================
# || TMUX BUG FIXES  ||
# =====================
if [ -z "$TMUX" ]; then
  # Known issues with tmux running this each time it opens a new buffer,
  # which is bad because we end up running multiple ssh agents simultaneously.
  # The following check on `$TMUX' helps filter it out so it's only run on a new
  # non-tmux session instead of every new tmux buffer.
  # 
  # One ssh agent to rule them all!

  # Setup SSH key password in-memory caching
  if [ -z "$SSH_AGENT_PID" ] || [ -z "$(ps --pid $SSH_AGENT_PID &>/dev/null)" ]; then
    eval "$(ssh-agent)"
  fi
fi
