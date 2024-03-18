function vitally
  set cmd $argv[1]

  if not contains $cmd start stop session-name init do
    echo "usage: vitally <CMD>; <CMD>: start, stop, session-name, init"
    return 1
  end

  if test $cmd = "do"
    set cmds (string replace -a ',' '' $argv[2..])
  else
    set cmds $cmd
  end

  for c in $cmds
    eval "vitally-$c"
  end
end
