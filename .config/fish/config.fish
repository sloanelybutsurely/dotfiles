eval (/opt/homebrew/bin/brew shellenv)
source /opt/homebrew/opt/asdf/libexec/asdf.fish
direnv hook fish | source

if status is-interactive
  fish_vi_key_bindings

  zoxide init fish | source
  
  if not set -q TMUX
    set -g TMUX tmux new-session -d -s default
    eval $TMUX
    tmux attach-session -d -t default
  end
end
