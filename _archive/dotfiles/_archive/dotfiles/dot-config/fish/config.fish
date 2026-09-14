fish_add_path -g ~/.local/bin

mise activate fish | source

if status is-interactive
	fish_vi_key_bindings
	zoxide init fish | source
end

abbr j jj

set -gx EDITOR nvim
set -gx MANPAGER 'nvim +Man!'

# pnpm
set -gx PNPM_HOME "/Users/sloane/Library/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end
