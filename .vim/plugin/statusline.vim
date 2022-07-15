" vertical dividing line between windows
hi VertSplit cterm=NONE gui=NONE guibg=NONE guifg=#9f4b3a

" Configures the status line.
"
" We'll use two types of highlighting:
"
" - StatusLine[Term][NC] (depending on window type and status), by default
"
"   The StatusLine[Term][NC] highlights defined below are **bold**;
"   StatusLine[Term] have colored backgrounds, StatusLine[Term]NC have colored
"   foreground text.
"
" - User1, using %1*...%*, and User2, using %2*...%*
"
"   Though User1 and User2 are defined with the same background color as 
"   StatusLine, %1*...%* applies the *difference* between a user style and
"   StatusLine. In effect, this means only the foreground color and text style
"   is affected.
"
"   User1 is used for nomal, non-bold text. User2 is used for alerts.
let s:User1 = { text -> '%1*' . text . '%*' }
let s:User2 = { text -> '%2*' . text . '%*' }
" Fixed is used for winfixwidth/winfixheight
let Fixed = { text, pred -> pred ? '«' . text . '»' : text }

let &statusline
  "\ the window number, to make it easy to use <C-w>[winnr]w
  \= s:User1("\u230a")."%{winnr()}".s:User1("\u2309")
  "\ the buffer number, for :b, :sb, etc.
  \. " %n ".s:User1("\u2237")
  "\ the buffer name; %< truncates the start of the name if it's too long
  \. " %<%{expand('%')}"
  "\ flags
  \. " ".s:User1
    "\ [+], [-] (modified flag
    \( "%m"
    "\ [hide], [unload], [delete], [wipe]
    \. "[%{&bufhidden != '' ? &bufhidden : &hidden ? 'hide' : 'unload'}]"
    "\ [RO] (readonly flag)
    \. "%r"
    "\ [Preview]
    \. "%w"
    "\ [help]
    \. "%h"
    "\ [Quickfix List], [Location List]
    \. "%q"
    \)
  "\ alerts
  \. s:User2
    "\ make it more obvious that we're recording a macro
    \( "%{reg_recording()==''?'':'[Macro]'}"
    "\ make it more obvious that we're in paste mode
    \. "%{&paste?'[Paste]':''}"
    \)
  "\ align the rest of the statusline to the right
  \. "%=".s:User1
    "\ unicode character under the cursor, as hexidecimal
    \( "0x%B"
    "\ (line number, column number)
    \. " (%l,%c%V)"
    "\ byte offset in file
    \. " +%o"
    "\ percentage offset in file
    \. " [%P]"
    "\ dimensions of window; using «…» to indicate if a dimension is locked via
    "\ winfixwidth or winfixheight
    \. " %{Fixed(winheight(0),&winfixheight).'✕'.Fixed(winwidth(0),&winfixwidth)}"
    \)

" an active non-terminal window uses bold black text
hi StatusLine guifg=#000000 gui=bold cterm=bold

" and a background depending on the mode:
" - Normal: green
" - Insert: orange
" - Command: blue
let StatusLineGuibg=#{Normal: "#5fffaa", Insert: "#ffaa5f", Command: "5faaff"}

" an inactive non-terminal window gets a grey statusbar with bold green text
hi StatusLineNC guibg=#777777 guifg=#5fffaa gui=bold cterm=bold

" an active terminal window gets a magenta statusbar with black text
hi StatusLineTerm guibg=#ff5fff guifg=#000000 gui=bold cterm=bold

" an inactive terminal window gets a grey status bar with magenta text
hi StatusLineTermNC guibg=#777777 guifg=#ff5fff gui=bold cterm=bold

" normal text is black
hi User1 guifg=#010101 gui=none cterm=none

" alerts are reversed, using the background color for text and a grey background
" (this hides them in NC windows)
hi User2 guifg=#777777 gui=bold,reverse cterm=bold,reverse

function! s:UpdateStatusLine(mode)
  let bgcolor = get(g:StatusLineGuibg, a:mode, '#ff0000')
  
  " we need User1 and User2's background to match StatusLine's for the difference to be correctly computed
  exec "hi User1 guibg=".bgcolor
  exec "hi User2 guibg=".bgcolor
  exec "hi StatusLine guibg=".bgcolor
  
  if a:mode == 'Command' && state('s') == ''
    " only switching to command mode doesn't automatically trigger
    " a statusline redraw; but it can cause issues if there's messages
    " currently showing, e.g. entering commands after :ls, the password
    " prompt for :X
    redrawstatus
  endif
endfunction

augroup statusline
  au!
  au InsertEnter * call s:UpdateStatusLine('Insert')
  au InsertLeave * call s:UpdateStatusLine('Normal')
  
  au CmdlineEnter * call s:UpdateStatusLine('Command')
  " the completion of < C-R>= doesn't trigger InsertEnter, so we need to use
  " CmdlineLeave to restore the insert settings
  au CmdlineLeave * call s:UpdateStatusLine(expand('<afile>') == '=' ? 'Insert' : 'NOrmal')
augroup END

call s:UpdateStatusLine('Normal')
  au CmdlineLeave * call s:UpdateStatusLine('Normal')
