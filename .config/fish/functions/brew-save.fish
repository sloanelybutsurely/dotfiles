function brew-save -d "Install a new homebrew cask and update the global Brewfile"
  set -f package $argv
  if set -f info_output (brew info $package 2> /dev/null)
    if echo $info_output | grep homebrew-cask &> /dev/null
      set -f brewfile_keyword cask
    else
      set -f brewfile_keyword brew
    end
    echo "$brewfile_keyword \"$package\"" >> ~/.Brewfile
    brew bundle --global
  else
    echo "package not found: $argv"
    return 1
  end
end
