eval (/opt/homebrew/bin/brew shellenv)
mise activate fish | source

if status is-interactive
  fish_vi_key_bindings

  zoxide init fish | source
  
  if not set -q TMUX
    set -g TMUX tmux new-session -d -s default
    eval $TMUX
    tmux attach-session -d -t default
  end
end

set -x EDITOR nvim

abbr -a g    git
abbr -a ga   git add
abbr -a gb   git branch
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

abbr -a nr   npm run

abbr -a y    yarn
abbr -a yb   yarn bootstrap
abbr -a ym   yarn migrate
abbr -a yf   yarn format-since

abbr -a mux  tmuxinator

# fix common "yadm" typos
abbr -a ydam yadm
abbr -a ydma yadm

# mise shorthands
abbr -a mr  mise run
