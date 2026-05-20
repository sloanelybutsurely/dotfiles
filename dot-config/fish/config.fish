fish_add_path -g ~/.local/bin

mise activate fish | source

if status is-interactive
	fish_vi_key_bindings
	zoxide init fish | source
end

abbr j jj

