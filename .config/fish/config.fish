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

abbr -a g    git
abbr -a ga   git add
abbr -a gc   git commit
abbr -a gcb  git checkout -b
abbr -a gco  git checkout
abbr -a gd   git diff
abbr -a gf   git fetch
abbr -a gp   git push
abbr -a gP   git push --force-with-lease
abbr -a gpl  git pull
abbr -a gplr git pull --rebase 
abbr -a gr   git rebase
abbr -a grr  git rebase --continue
abbr -a gst  git status
abbr -a gca  git commit -a

abbr -a fug  nvim +Git +only
