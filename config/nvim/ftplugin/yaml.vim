" Vim indent file
" Language: Yaml
" Author: Ian Young

set foldmethod=indent
nnoremap <silent> <Leader>O :set foldlevel=9<CR>

" if exists('b:did_indent')
"   finish
" endif
" "runtime! indent/ruby.vim
" "unlet! b:did_indent
" let b:did_indent = 1
" 
" setlocal autoindent sw=2 et
" setlocal indentexpr=GetYamlIndent()
" setlocal indentkeys=o,O,*<Return>,!^F
" 
" function! GetYamlIndent()
"   let l:prevlnum = v:lnum - 1
"   if l:prevlnum == 0
"     return 0
"   endif
"   let l:line = substitute(getline(v:lnum),'\s\+$','','')
"   let l:prevline = substitute(getline(l:prevlnum),'\s\+$','','')
" 
"   let l:indent = indent(l:prevlnum)
"   let l:increase = l:indent + &shiftwidth
"   let l:decrease = l:indent - &shiftwidth
" 
"   if l:prevline =~? ':$'
"     return l:increase
"   elseif l:prevline =~? '^\s\+\-' && l:line =~? '^\s\+[^-]\+:'
"     return l:decrease
"   else
"     return l:indent
"   endif
" endfunction

" vim:set sw=2:
