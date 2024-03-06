function ls
  command eza --all \
    --long \
    --group-directories-first \
    --tree \
    --level=1 \
    --header \
    --icons \
    --no-permissions \
    --no-user \
    --no-time \
    --git \
    $argv
end
