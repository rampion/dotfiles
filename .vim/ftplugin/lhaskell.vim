nnoremap <buffer> ,, :HdevtoolsType<CR>
nnoremap <buffer> ;; :HdevtoolsClear<CR>

if !exists('g:lhaskell_ftplugin_loaded') || !g:lhaskell_ftplugin_loaded
  let g:lhaskell_ftplugin_loaded = 1
  let $HSCOLOUR_CSS="~/.vim/ftplugin/lhaskell/hscolour.css"
  au BufWritePost *.lhs !hscolour -lit -css "%" | pandoc --no-wrap -sS -c $HSCOLOUR_CSS -o "%:r.html"
end
