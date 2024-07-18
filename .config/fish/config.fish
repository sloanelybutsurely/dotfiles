eval "$(/opt/homebrew/bin/brew shellenv)"

if status is-interactive
  fish_vi_key_bindings
  mise activate fish | source
  mise hook-env -s fish | source
  jj util completion fish | source

  zoxide init fish | source
  
  if not set -q TMUX
    set -g TMUX tmux new-session -d -s default
    eval $TMUX
    tmux attach-session -d -t default
  end
end
