set nocompatible

lua require('plugins')

set number
set relativenumber

set tabstop=2
set shiftwidth=2
set expandtab

set mouse=a

au BufRead,BufNewFile *.ex,*.exs set filetype=elixir
au BufRead,BufNewFile *.eex,*.heex,*.leex,*.sface,*.lexs set filetype=eelixir
au BufRead,BufNewFile mix.lock set filetype=elixir
