nnoremap <buffer> ,, :HdevtoolsType<CR>
nnoremap <buffer> ;; :HdevtoolsClear<CR>
"nnoremap <buffer> %% :HdevtoolsInfo<CR>

setlocal include=^import\\s*\\%(qualified\\)\\?\\s*
setlocal includeexpr=substitute(v:fname,'\\.','/','g').'.'
setlocal suffixesadd=hs,lhs,hsc
