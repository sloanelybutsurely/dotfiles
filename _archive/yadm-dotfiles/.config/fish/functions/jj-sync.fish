function jj-sync
    jj git fetch
    jj rebase -b 'all:bookmarks() & mine() ~ trunk()' -d 'trunk()' --skip-emptied
    jj git push --tracked
end
