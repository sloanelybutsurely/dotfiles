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

abbr -Ua g    git
abbr -Ua gp   git push --force-with-lease
abbr -Ua gf   git fetch
abbr -Ua gpl  git pull
abbr -Ua gplr git pull --rebase 
abbr -Ua gst  git status
abbr -Ua gcb  git checkout -b
abbr -Ua gco  git checkout
abbr -Ua ga   git add
abbr -Ua gc   git commit
abbr -Ua grr  git rebase --continue
abbr -Ua gr   git rebase


abbr -Ua fug  nvim +Git +only
