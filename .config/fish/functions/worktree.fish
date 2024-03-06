# inspired heavily by https://github.com/llimllib/personal_code/blob/daab9eb1da9f777df57c742e5629247a94b54947/homedir/.local/bin/worktree

function worktree
  set branchname $argv[1]
  set dirname (string replace -a "/" "_" $branchname)

  if not git pull
    echo "Unable to run git pull, there may not be an upstream"
  end

  if git for-each-ref --format='%(refname:lstrip=2)' refs/heads | grep -E "^$branchname\$" > /dev/null 2>&1
    git worktree add "../$dirname" "$branchname"
  else if git for-each-ref --format='%(refname:lstrip=3)' refs/remotes/origin | grep -E "^$branchname\$" > /dev/null 2>&1
    git worktree add "../$dirname" "$branchname"
  else
    git worktree add -b "$branchname" "../$dirname"
  end

  if test -d "node_modules"
    cp -Rc node_modules ../$dirname/node_modules
  end
end