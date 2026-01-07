fish_add_path -g ~/.local/bin

if status is-interactive
	fish_vi_key_bindings
	zoxide init fish | source

  abbr j jj
end
