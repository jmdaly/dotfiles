" Author: jmdaly <jmdaly@gmail.com>
" Description: pc-lint linter for c files 

call ale#Set('c_pclint_executable', 'pclp64_linux')
call ale#Set('c_pclint_options', '')

" Get the full command line to run. Append contents from thje c_pclint_options
" variable if it exists. We format the output the way gcc does here, so that
" we can use the gcc format handler.
function! ale_linters#c#pclint#GetCommand(buffer) abort
  return '%e'
  \  . ale#Pad('-h1 -width\(0,0\) -"format=%(%f:%l:%C %) %%t: %m"')
  \  . ale#Pad(ale#Var(a:buffer, 'c_pclint_options'))
  \  . ' %t'
endfunction

" Register pclint for `c` files
call ale#linter#Define('c', {
\  'name': 'pclint',
\  'executable': {b -> ale#Var(b, 'c_pclint_executable')},
\  'command': function('ale_linters#c#pclint#GetCommand'),
\  'callback': 'ale#handlers#gcc#HandleGCCFormat',
\})
