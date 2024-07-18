eval "$(/opt/homebrew/bin/brew shellenv)"

mise activate fish | source

if status is-interactive
  fish_vi_key_bindings
  
  if not set -q TMUX
    set -g TMUX tmux new-session -d -s default
    eval $TMUX
    tmux attach-session -d -t default
  end

  zoxide init fish | source
  jj util completion fish | source
end
