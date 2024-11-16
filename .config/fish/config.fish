eval "$(/opt/homebrew/bin/brew shellenv)"

if status is-interactive
  fish_vi_key_bindings
  mise activate fish | source
  mise hook-env -s fish | source
  direnv hook fish | source
  zoxide init fish | source

  jj util completion fish | source
  
  # start or attach to default tmux session
  if not set -q TMUX
    set -g TMUX tmux new-session -d -s default
    eval $TMUX
    tmux attach-session -d -t default
  end
end

set -xg SSH_AUTH_SOCK ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

abbr j    jj
abbr jd   jj desc 
abbr jst  jj st
