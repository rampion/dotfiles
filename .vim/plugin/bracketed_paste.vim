" adapted from https://github.com/aaronjensen/vimfiles/blob/2a88ef0b92f5a628e898189e612eb0feb34b1419/vimrc#L449-483

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tmux wrapping borrowed from vitality.vim: https://github.com/sjl/vitality.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This fixes pasting from iterm (and some other terminals) by using
" "bracketed paste mode"
" aaronjensen modified it to work in tmux and not wait for esc
"
" See: http://stackoverflow.com/questions/5585129/pasting-code-into-terminal-window-into-vim-on-mac-os-x
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" toggle bracketed paste when entering/leaving insert mode
let &t_SI = WrapForTmux("\<Esc>[?2004h") . &t_SI
let &t_EI = WrapForTmux("\<Esc>[?2004l") . &t_EI

" enter paste mode and be on the lookout for the end paste bracket
" to know when to leave it
function BracketedPasteBegin(ret)
    set pastetoggle=<Esc>[201~
    set paste
    return a:ret
endfunction

execute "set <f28>=\<Esc>[200~"
execute "set <f29>=\<Esc>[201~"
imap <expr> <f28> BracketedPasteBegin("")
