setlocal errorformat^=
      \%E###\ Failure\ in\ %f:%l:\ %m,
      \%+C\expected:\ %.%#,
      \%+C\ but\ got:\ %.%#,
      \%+C\ \ \ \ \ \ \ \ \ \ %.%#,
      \%-GExamples:\ %\\d%\\+\ \ Tried:\ %\\d%\\+\ \ Errors:\ %\\d%\\+\ \ Failures:\ %\\d%\\+

nnoremap <buffer> ,, :HdevtoolsType<CR>
nnoremap <buffer> ;; :HdevtoolsClear<CR>
"nnoremap <buffer> %% :HdevtoolsInfo<CR>

setlocal include=^import\\s*\\%(qualified\\)\\?\\s*
setlocal includeexpr=substitute(v:fname,'\\.','/','g').'.'
setlocal suffixesadd=hs,lhs,hsc
