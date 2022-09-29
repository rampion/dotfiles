source $VIMRUNTIME/vimrc_example.vim

" Assume terminals that advertise 256 colors can handle truecolor (256^3 colors)
if $TERM =~ "-256color"
  " When 24-bit color is enabled for terminal, the terminal background is opaque.
  " Disabling that fixes the issue for now For more see `github.com/vim/vim/issues/2361`
  " set notermguicolors
  let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
  let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
  set termguicolors
endif

" hide the scroll, menu, and tool bars in GVIM
set guioptions=aegit

colorscheme gruvbox
let g:gruvbox_sign_column="bg0"
let g:gruvbox_contrast_dark="medium"

hi Normal ctermbg=NONE guibg=NONE

" set this after `hi Normal` otherwise it is ignored
set background=dark

hi NonText ctermbg=NONE guibg=NONE
hi Terminal guibg=#000000

set cindent

" don't display '\t' characters, use two ' ' instead
set tabstop=2
" don't leave them as tabs in the file
set expandtab
" shift left or right by two ' ' characters when using < or > commands
set shiftwidth=2
" you can hit backspace to jump back two ' ' characters in insert mode (as if deleting a single tab).  the x command still deletes a single ' ' though.
set softtabstop=2

" set the text width
set tw=80
" c: automatically wrap comments
" q: allow rewrapping of comments w/ gq
" r: automatically insert comment character
" l: don't break previously long lines
set formatoptions=cqrlo

" show the line numbers in-line
set number

" get rid of the audible bell
set visualbell noerrorbells

" ignore case in string matching, unless one of the characters is uppercase
set ignorecase
set smartcase

" don't highlight matching parens - takes too long
let loaded_matchparen = 1 "  help matchparen

" don't print line numbers for TOhtml, by default
let html_number_lines = 0

" When editing a crontab file, set backupcopy to yes, rather than auto. See :help crontab and bug #53437
autocmd FileType crontab set backupcopy=yes
autocmd FileType dot set backupcopy=yes

" use "Space" for leader
let mapleader=" "

" jrpat4's trick for listing current buffers
map <Leader>b :ls<cr>:b

augroup backup
  " Save backups of files in a parallel tree under ~/.backup, with each version
  " tagged with the date and time.
  
  " Make sureto have a cronjob or something regulalrly clear out stale entries
  " ie `find ~/.backup -not -newerat "1 month ago" -delete`
  
  " We could instead use `~/.backup//` to store all the backups in a flat
  " directory with using an escaped full path as the backup file name (/'/ -> '%'),
  " but that fails when the file's path is very long (looking at you heavily
  " nested java source trees
  au BufWritePre *
        \ let &l:backupext=strftime(";%FT%T") |
        \ let &l:backupdir=$HOME.'/.backup'.expand("%:p:h") |
        \ echo system("mkdir -p " . &backupdir)
augroup END

" match last yanked or deleted text
nnoremap ,/ /\V<C-R> =substitute
      \substitute(getreg('"'), "[\\/]", '\\\0', 'g')
      \, "\n", '\\n', 'g')<CR><CR><CR>

" use & to add words to the current search pattern
nnoremap & :let @/.='\\|\<'.expand("<cword>").'\>'<CR>

" use <Tab> to tab through jumplist
nnoremap <S-Tab> <C-O>

" use <C-W>vf to open the file under the cursor in a new (vertical) window
nnoremap <C-W>vf :vertical wincmd f<CR>

" always show a status line
set laststatus=2

" use K to open man pages in a new vim window, rather than in a pager (default)
let $GROFF_NO_SGR=1 " see man grotty
source $VIMRUNTIME/ftplugin/man.vim
set keywordprg=:Man

" auto fold stuff by indent
set foldmethod=indent
set foldlevelstart=99

" highlight columns past 80
highlight ColorColumn ctermbg=magenta
function EnableEightyColumnLimit()
  let w:eighty_column_match = matchadd('ColorColumn', '\%51v.\+', 100)
endfunction
function ToggleEightColumnLimit()
  if exists ('w:eighty_column_match')
    call matchdelete(w:eighty_column_match)
    unlet w:eighty_column_match
  else
    call EnableEightyColumnLimit()
  endif
endfunction
command ToggleEightyColumnLimit :call ToggleEightyColumnLimit()

" highlight tabs and trailing spaces
set listchars=tab:⟥⟞,trail:∙
set list

set modeline
set modelines=1

" set completion options to automatically list available completions
set wildmenu
set wildmode=lastused:full

" use SPACE-p to toggle between paste/nopaste
nnoremap <Leader>p :set paste! paste?<CR>
" use SPACE-s to see the syntax group of the item under the cursor
nnoremap <Leader>s :echo
      \ 'hi<'.synIDattr(synID(line("."),col("."),1),"name").'> '.
      \ 'trans<'.synIDattr(synID(line(".",col("."),0),"name").'> '.
      \ 'lo<' .synIDattr(synIDtrans(synID(line("."),col("."),1)),"name").'>'<CR>

" useful for escaping code for html
" %s/[<>%]/\html_escapes(submatch(0))/g
let html_escapes={'<':'&lt;','>':'&gt;','&':'&amp;'}
command -range EscapeTags <line1>,<line2>s/[<>%]/\=html_escapes[submatch(0)]/g

" templates for blank files (:help template)
au BufNewFile *.{htm,html} r ~/.vim/templates/skeleton.html | 1d
au BufNewFile ~/Documents/wiki/diary/\d\d\d\d-\d\d-\d\d.md call setline(1, strftime("# %Y-%m-%d, %A", strptime("%Y-%m-%d", expand("%:t:r"))))

" let vim unload memory used for buffers not currently being displayed
set nohidden

" but completely close ones from fugitive
au BufReadPost fugitive://* setlocal bufhidden=wipe

" and empty unnamed buffers
"
" uses setbufvar() rather than `set` because `set` affects the buffer
" that was in focus when the new buffer was created, not the new buffer)
autocmd! BufNew {} call setbufvar(str2nr(expand("<abuf>")), "&bufhidden", "wipe")

" but if an unnamed buffer becomes named, use the default behaviour
"
" (BufNew is called after renaming)
autocmd! BufNew *?* call setbufvar(str2nr(expand("<abuf>")), "&bufhidden", "")

" or if it becomes a terminal
autocmd! TerminalOpen * set bufhidden=

nnoremap <Leader>u :GundoToggle<CR>

" when `:make` jumps to errors, use the previous window
set switchbuf=uselast

" allow project to have their own .vimrc files
set secure " don't let them do anything nefarious
set exrc

" use a good encryption algorithm for encypted files
set cryptmethod=blowfish2

" don't print scp messages when saving remote files
let g:netrw_silent=1

" don't use the popup when printing netrw errors - I always forget how to clear popup errors (:call popup_clear())
let g:netrw_use_errorwindow=0

" bind q@ to access the input() history (like q: or q/)
nnoremap q@ :echo input('')<CR><C-F>

" show wrapped lines if they continue off the bottom of the screen
set display=lastline,uhex

nnoremap <Leader>m :make<CR>

" make diffs more legible
hi DiffAdd ctermbg=black
hi DiffChange ctermbg=black
hi DiffDelete ctermbg=blue ctermfg=black
hi DiffText cterm=reverse ctermbg=NONE ctermfg=NONE

" hide swapfiles w/in netrw
let g:netrw_list_hide='.%\.swp$'
let g:netrw_altv_=1 " windows opened with 'v' open on the right
let g:netrw_browse_split=0 " open current file with <CR> in the same window
let g:netrw_banner=0 " hide the Netrw banner
let g:netrw_preview = 1 " open current file with p in vertical split, keep cursor in netrw
let g:netrw_liststyle = 3 " use tree view
let g:netrw_winsize = 80 " keep netrw in 80 columns

nnoremap <Leader>l :if exists(':Rexplore') <bar> exec 'Rexplore' <bar> else <bar> Explore <bar> endif<CR>

" enable jsx highlighting in js files
let g:jsx_ext_required = 0

" make text wrapping more obvious but less annoying
set wrap linebreak breakindent showbreak=…
hi NonText ctermfg=208

" expand <C-c> to word under cursor in command mode
cnoremap <C-c> <C-r>=expand("<cword">)<CR>

" default to using the X clipboard for copy/paste
set clipboard=unnamedplus

" TODO: migrate to an appropriate plugin
" settings for when in a maven-managed directory
if filereadable("pom.xml")
  if !filereadable('Makefile')
    let &makeprg="mvn compile"
  endif
  
  " %C…WARNING before %W…WARNING to group all warnings into one so it only
  " requires one :cn to skip past them
  "
  " INFO messages are removed by defaultLogLevel=INFO in ~/.mavenrc
  let &errorformat=join([
        \"%C[\e[1;33mWARNING\e[m]%m",
        \"%W[\e[1;33mWARNING\e[m]%m,
        \"%-E[\e[1;31mERROR\e[m] %\\w%\\+ errors found",
        \"%-E[\e[1;31mERROR\e[m] Failed to execute goal %m",
        \"%-E[\e[1;31mERROR\e[m] ",
        \"%E[\e[1;31mERROR\e[m] [Error] %f:%l: %m",
        \"%E[\e[1;31mERROR\e[m] %f:%l: %m",
        \"%-Z[\e[1;31mERROR\e[m] %p^",
        \"%-C[\e[1;31mERROR\e[m] %s",
        \], ",")
endif

" use fzf to search for unicode codepoints
"
" depends on fzf.vim (from fzf-0.17.3.tar.gz) and unicode.vim (from
" https://gitlab.com/chrisbra/unicode.vim)
runtime START autoload/unicode/UnicodeData.vim

let unicodeIndex = {}
let name_column_width=max(map(values(g:unicode#unicode#data), {_, name -> strdisplaywidth(name)}))
for [codepoint,name] in items(g:unicode#unicode#data)
  let char = nr2char(codepoint)
  let unicodeIndex[printf("U+%05x\t%*s\t%s", codepoint, -name_column_width, name, char)] = char
endfor
let unicodeIndexKeys = sort(keys(unicodeIndex))

inoremap <expr> <C-K><C-K> fzf#vim#complete(fzf#wrap({
      \ 'prefix': '',
      \ 'source': unicodeIndexKeys,
      \ 'options': '--height 10',
      \ 'reducer': { lines -> g:unicodeIndex[lines[0]] }}))
" todo: add tnoremap equivalent

" configure FZF to use a terminal buffer
let g:fzf_layout = {'window': 'belowright 30new'}

" ale configuration from https://github.com/MercuryTechnologies/mercury-web-backend/blob/master/docs/environment/editors.md
let g:ale_linters = { 'haskell':    ['hlint'] }
let g:ale_fixers =  { 'haskell':    ['ormolu'] }
let g:ale_haskell_hlint_options = '--refactor'
let g:ale_haskell_ormolu_executable="fourmolu"
let g:ale_fix_on_save = 1

" configure ale to use the preview window (a bit noisy)
"let g:ale_cursor_detail=1

" render <Shift-Space> as <Space>
tnoremap <S-Space> <Space>

" use <C-W>i to insert arbitrary text using insert-mode bindings
tnoremap <C-W>i <C-W>"=insert("insertr: ")<CR>

" use <C-K> to insert a digraph in the terminal
tnoremap <silent> <C-K> <C-W>"=digraph_get(nr2char(getchar()) . nr2char(getchar()))<CR>

" use <C-R> to paste a register in terminal mode
tnoremap <C-R> <C-W>"

" use <C-W>s and <C-W>v within a terminal to create a new terminal
tnoremap <C-W>s <C-W>:terminal<CR>
tnoremap <C-W>v <C-W>:vert terminal<CR>

" easily insert lines without comment continuations
nnoremap <Leader>o o<Esc>^Da
nnoremap <Leader>O O<Esc>^Da

" configure vimwiki
let g:vimwiki_global_ext = 0
let g:vimwiki_folding = 'custom'
let g:vimwiki_list = 
    \[ {'path': '~/Documents/wiki/'
      \,'syntax': 'markdown'
      \,'ext': '.md'
      \,'nested_syntaxes':
        \{ 'haskell': 'haskell'
        \, 'ruby': 'ruby'
        \, 'python': 'python'
        \, 'c': 'c'
        \, 'scala': 'scala'
        \, 'java': 'java'
        \, 'js': 'javascript'
        \, 'sh': 'sh'
        \, 'ts': 'typescript'
        \, 'zsh': 'zsh'
        \, 'xml': 'xml'
        \, 'vim': 'vim'
        \}
      \}
    \]
command! -nargs=1 VWG VimwikiGoto <args>

let g:markdown_fenced_languages = [
      \'haskell',
      \'ruby',
      \'python',
      \'c',
      \'scala',
      \'java',
      \'js=javascript',
      \'sh',
      \'ts=typescript',
      \'zsh',
      \'xml',
      \'vim'
      \]
" don't autoconceal ```lang... ``` ticks
let g:markdown_syntax_conceal=0

" fetch environment variables for current session from tmux
function UpdateEnvironment()
  for line in systemlist('tmux show-env')
    let ix = match(line, '^[^-]\w\+\zs=')
    if ix > -1
      call setenv(line[:ix-1], line[ix+1:])
    endif
  endfor
endfunction

command UpdateEnvironment :call UpdateEnvironment
command UP windo up

if &term =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is
  " combined with `set-window-option -g xterm-keys on` in ~/.tmux.conf
  " this makes bindings for <C-Up>, <C-Down> etc work as expected
  "
  " https://superuser.com/questions/401926
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1*C"
  execute "set <xLeft>=\e[1;*D"
end

" use <C-P> and <C-N> instead of ↑ and ↓ for command line history navigation
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
cnoremap <Up> <Nop>
cnoremap <Down> <Nop>

" monkey with the highlighting
hi SpecialKey gui=bold
hi NonText guifg=#fe8019

" automatically format with rustfmt when editing rust files
let g:rustfmt_autosave=1

" An all-purpose path
"
" `.`    search directory of current file
" `.;`   search upwards from the current files director
" ``     search working directory (`:pwd`)
" `;`    search upwards from working directory
"
" Avoid using ./** or ** to search downward from current file or directory as
" that can be too inclusive, instead use :AddGitPath
set path=.,.;,,;

" Set the path to autocomplete to all the things in the git repository
"
" optional argument is directory containing .git directory
"
" defaults to current buffer's closest ancestor with a .git directory
function! AddGitPath(...)
  let l:gitdir = substitute(fnamemodify(a:0 ? FugitiveGitDir(a:1) : FugitiveGitDir(), ':p'), '.git/\?$', '', '')
  silent let l:result = system('git --git-dir "' . l:gitdir . '.git" ls-files -z')
  
  if v:shell_error
    echoe l:result
    return
  endif
  
  let &path.=','.
    \l:result
    \->split("\x01")
    \->map({ix,path -> fnamemodify(l:gitdir . path, ':h')})
    \->sort()
    \->uniq()
    \->join(',')
endfunction
 
command! -bar -nargs=? -complete=dir AddGitPath call AddGitPath(<f-args>)
 
" run a pipeline of commands in a terminal
command! -complete=file -nargs=+ Zsh terminal zsh -c <q-args>
 
" get rid of lag when hitting <Esc> in a terminal
au TerminalOpen * if &buftype == 'terminal' | setlocal ttimeoutlen=0 | endif
 
" don't add a trailer newline to files if they don't already have one, it makes
" for messier commit diffs
set nofixendofline

" change vertical separator between windows
set fillchars+=vert:│

" coc.nvim
" - bring up a menu of possible quickfixes
nnoremap <leader>f :CocFix<CR>
