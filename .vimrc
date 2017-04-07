source $VIMRUNTIME/vimrc_example.vim

" see |:help vimrc-filetype|
" (enable fieltype detection and indenting)
filetype plugin indent on " needed for NeoBundle

if isdirectory('~/.vim/bundle/neobundle.vim') || 
      \ system('git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim')

  " manage bundles with NeoBundle
  set runtimepath+=~/.vim/bundle/neobundle.vim/

  call neobundle#begin(expand('~/.vim/bundle/'))
  NeoBundleFetch 'Shougo/neobundle.vim'
  NeoBundle	'https://github.com/rust-lang/rust.vim.git'
  NeoBundle	'https://github.com/scrooloose/syntastic.git'
  NeoBundle	'https://github.com/tpope/vim-fugitive.git'
  NeoBundle	'https://github.com/bitc/vim-hdevtools.git'
  NeoBundle	'https://github.com/cespare/vim-toml.git'
  NeoBundle	'https://github.com/HerringtonDarkholme/yats.vim.git'
  NeoBundle	'https://github.com/valloric/youcompleteme'
  call neobundle#end()

  " If there are uninstalled bundles found on startup,
  " this will conveniently prompt you to install them.
  NeoBundleCheck
endif

syntax on " enable syntax coloring by default

colo desert " a slightly more muted colorscheme

" two space indent by default
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" put timestamped backup copies of files in ~/.vim/backup
let bud = $HOME . "/.vim/backup"
if isdirectory( bud ) == 0
  call mkdir(bud, "p")
  " clean the directory weekly with crontab
  call system('(crontab -l ; echo ''@midnight find '.bud.' -not -newerat "1 week ago" -delete'') | crontab -')
endif
let &backupdir=bud
au BufWritePre * let &backupext = ' ' . substitute(expand('%:p:h'),'/',':', 'g') . ' ' . strftime("%Y.%m.%d %H:%M:%S")

" check top/bottom two lines for vim commands
set modeline modelines=2

" display line numbers relative to cursor position
set number relativenumber

" disable wrapping and indicate sidescrolling
set nowrap sidescroll=5 listchars+=precedes:↩,extends:↪

" enable per-project .vimrc
set exrc secure

" use <Space> as <Leader> for custom mappings
let maplocalleader = " "
let mapleader = " "

" use <Tab>/<S-Tab> to switch between tabs
nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabprevious<CR>

" easily make / make build / make test
nnoremap <Leader>m :make<CR>
nnoremap <Leader>b :make build<CR>
nnoremap <Leader>t :make test<CR>
