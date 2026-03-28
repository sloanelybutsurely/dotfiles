fish_add_path -g ~/.local/bin

if status is-interactive
	fish_vi_key_bindings
	zoxide init fish | source

  abbr j jj
  abbr hex hexyl
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/sloane/.lmstudio/bin
# End of LM Studio CLI section

