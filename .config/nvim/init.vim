set nocompatible

" download vim-plug if missing
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
  silent! execute '!curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * silent! PlugInstall
endif

call plug#begin(stdpath('data') . '/plugged')
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-abolish'

  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'

  Plug 'christoomey/vim-sort-motion'

  Plug 'kana/vim-textobj-user'
  Plug 'kana/vim-textobj-indent'
  Plug 'kana/vim-textobj-line'

  Plug 'kyazdani42/nvim-web-devicons'

  Plug 'christoomey/vim-tmux-navigator'

  Plug 'preservim/nerdtree'

  Plug 'tversteeg/registers.nvim'

  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'

  Plug 'duane9/nvim-rg'

  Plug 'tversteeg/registers.nvim'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'ibhagwan/fzf-lua'

  Plug 'elixir-editors/vim-elixir'

  Plug 'dracula/vim', { 'as': 'dracula' }
call plug#end()


syntax enable
filetype plugin indent on

if !exists('g:vscode')
  colorscheme dracula
endif

set number
set relativenumber

set tabstop=2
set shiftwidth=2
set expandtab

set mouse=a

set cmdheight=2

set nobackup
set nowritebackup

set spell

let mapleader=','

nnoremap ; :
nnoremap q; q:
vnoremap ; :
vnoremap q; q:

if exists('g:vscode')
  nnoremap <Leader>w :Write<CR>
  nnoremap <Leader>wq :Write<CR>:q<CR>
else
  nnoremap <Leader>w :w<CR>
  nnoremap <Leader>wq :wq<CR>
endif

nnoremap <Leader>q :q<CR>

nnoremap <silent> <ESC> :nohlsearch<CR>

nnoremap <Leader><Tab> :NERDTreeToggle<CR>

"  Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

nnoremap <Leader>~ :split ~/.config/nvim/init.vim<CR>
nnoremap <Leader>so :so %<CR>

nnoremap <Leader>f  <cmd>lua require('fzf-lua').files()<CR>
nnoremap <Leader>a  <cmd>lua require('fzf-lua').grep_project()<CR>

" nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>gp :Git push --force-with-lease -u origin head<CR>
nnoremap <Leader>gf :Git fetch<CR>
nnoremap <Leader>gr :Git rebase origin/main<CR>
nnoremap <Leader>gb :Git checkout -b 

if !exists('g:vscode')
  luafile ~/.config/nvim/lua/lsp-setup.lua
endif

" lua require('gitsigns').setup()

lua << EOF
  require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF

nnoremap <Leader>o :only<CR>

" Terminal mode
tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
