function run
  eval "$argv[1]-$argv[2]"
end

function usage
  set fn $argv[1]
  set allowed $argv[2..]
  echo "Usage: $fn <CMD>"
  echo "       $fn do <CMD>[, <CMD>]"
  echo "  <CMD>:" (string join ", " $allowed)
end

function available-cmds
  string replace --filter --regex "^$argv[1]-" "" (functions --name)
end

function prefixed-function
  set fn $argv[1]
  set allowed (available-cmds $fn)

  if test $argv[2] = "do"
    set cmds (string replace -a ',' '' $argv[3..])
  else
    set cmds $argv[2]
  end

  for cmd in $cmds
    if not contains $cmd $allowed
      echo "Error: Unknown subcommand '$cmd'"
      usage $fn $allowed
      return 1
    end
  end

  for cmd in $cmds
    run $fn $cmd
  end
end
