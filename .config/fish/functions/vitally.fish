function vitally
  set cmd $argv[1]
  set cmds start stop session-name
  if not contains $cmd $cmds
    echo "usage: vitally <CMD>; <CMD>: start, stop, session-name"
  else
    eval "vitally-$cmd"
  end
end
