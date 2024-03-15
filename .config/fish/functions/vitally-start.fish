function vitally-start
  set session $(vitally session-name)
  set workdir $(pwd)

  vitally stop

  tmux new-session -d -s $session -c $workdir
  tmux new-window -t "$session:" -n "build" -c $workdir
  tmux new-window -t "$session:" -n "client" -c $workdir
  tmux new-window -t "$session:" -n "server" -c $workdir
  tmux new-window -t "$session:" -n "surveys-api" -c $workdir
  tmux new-window -t "$session:" -n "job-runner" -c $workdir
  
  tmux send-keys -t "$session:build" "yarn migrate" Enter
  tmux send-keys -t "$session:build" "yarn build:watch" Enter
  tmux send-keys -t "$session:client" "sleep 30; yarn client:start" Enter
  tmux send-keys -t "$session:server" "sleep 35; yarn server:start" Enter
  tmux send-keys -t "$session:surveys-api" "sleep 35; yarn surveys:start" Enter
  tmux send-keys -t "$session:job-runner" "sleep 40; yarn job-runner:start" Enter
end
