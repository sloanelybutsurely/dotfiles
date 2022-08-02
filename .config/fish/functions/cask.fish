function cask -d "Install a new homebrew cask and update the global Brewfile"
  echo "cask \"$argv\"" >> ~/.Brewfile
  brew bundle --global
end
