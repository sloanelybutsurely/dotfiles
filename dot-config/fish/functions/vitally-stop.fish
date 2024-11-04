function vitally-stop
  tmux kill-session -t $(vitally session-name) > /dev/null 2>&1
end
