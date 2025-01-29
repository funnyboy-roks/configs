" This is a very simple .vimrc that I can use on my servers where I don't want
" to install neovim and my full config (which tends to be a lot of steps, and
" more than is ever needed).
"
" This is effectively a simplified version of my init.vim (/nvim/init.vim in this repo)
" Download with:
"     wget -O ~/.vimrc https://raw.githubusercontent.com/funnyboy-roks/personal-config/main/.vimrc

let mapleader = "\<Space>"

map <C-p> :Files<CR>
nmap <leader>; :Buffers<CR>
nmap <leader>w :w<CR>

syntax on

filetype plugin indent on
set autoindent
set timeoutlen=300 " http://stackoverflow.com/questions/2158516/delay-before-o-opens-a-new-line
set encoding=utf-8
set scrolloff=2
set mouse=a
set hidden
set nowrap
set nojoinspaces
let g:sneak#s_next = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_frontmatter = 1

" always draw sign column
set signcolumn=yes

" permanent undo
set undodir=~/.vimdid
set undofile

set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" proper search
set incsearch
set ignorecase
set smartcase
set gdefault

" search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/

set guioptions-=T
set vb t_vb=
set backspace=2
set nofoldenable
set ttyfast
set lazyredraw
set synmaxcol=500
set laststatus=2
set relativenumber
set number
set diffopt+=iwhite " no whitespace in vimdiff
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic
set showcmd
nnoremap ; :

nnoremap <C-j> <Esc>
inoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
snoremap <C-j> <Esc>
xnoremap <C-j> <Esc>
cnoremap <C-j> <C-c>
onoremap <C-j> <Esc>
lnoremap <C-j> <Esc>
tnoremap <C-j> <Esc>

map H ^
map L $

" Note: for this to work, vim needs to be compiled with clipboard support --
" i.e. when you install vim-gtk on ubuntu.  Without it, the `+` register gets
" ignored and just copies to the unnamed register
noremap <leader>p "+p
noremap <leader>y "+y

" no arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" move by visual line
noremap j gj
noremap k gk

" <esc> is needed because vim doesn't like `<M-j>` in a lot of terminals
nnoremap <esc>j 10gj
nnoremap <esc>k 10gk

" toggle between buffers
nnoremap <leader><leader> <c-^>

" show/hide hidden characters
nnoremap <leader>, :set invlist<cr>

" show stats
nnoremap <leader>q g<c-g>

" I know how to use vim, thanks
nnoremap <c-c> <nop>

" make it such that copying over ssh is a bit easier by removing line numbers
" and sign column (for copying in Alacritty)
" This feels like a bit of a hacky solution.  One could alternatively have the
" clipboard version of Vim installed on the ssh session, and set the following
" in their ssh config.
"   ForwardX11 yes
"   ForwardX11Trusted yes
"
" I'm using this because it allows me to use vim without the clipboard
" integration on servers where I have less control.
nnoremap <leader>Y :set number! \| set relativenumber! \| set signcolumn=no<cr>
" reset back to "normal" layout
nnoremap <leader><Esc> :set number \| set relativenumber \| set signcolumn=yes<cr>

command Paste redir @+>|silent execute "write !curl -X POST https://api.pastes.dev/post -H 'Content-Type: text/" . &ft . "' --data-binary '@-' 2> /dev/null | jq -r '\"https://pastes.dev/\" + .key' | xargs"|redir END|let @+ = substitute(@+, '[^0-9a-z:/]', '', 'gi')|echom @+

" Map C-j and C-k to Down and Up for things like the command line
snoremap <C-j> <Down>
xnoremap <C-j> <Down>
cnoremap <C-j> <Down>
onoremap <C-j> <Down>
lnoremap <C-j> <Down>
tnoremap <C-j> <Down>

snoremap <C-k> <Up>
xnoremap <C-k> <Up>
cnoremap <C-k> <Up>
onoremap <C-k> <Up>
lnoremap <C-k> <Up>
tnoremap <C-k> <Up>
