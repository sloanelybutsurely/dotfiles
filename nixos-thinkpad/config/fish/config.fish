fish_add_path -g ~/.local/bin

if type -q mise
  mise activate fish | source
end

if status is-interactive
	fish_vi_key_bindings
	zoxide init fish | source
end

abbr j jj

set -gx EDITOR nvim
set -gx MANPAGER 'nvim +Man!'

function rebuild-system ()
  sudo nixos-rebuild switch --flake ~/.config/nixos\#(hostname)
end
