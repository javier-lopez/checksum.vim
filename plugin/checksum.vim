" ============================================================================
" File:        checksum.vim
" Description: vim global plugin to cryptographically checksum files
" Maintainer:  Javier Lopez <m@javier.io>
" License:     WTFPL
" ============================================================================

" Init {{{1
if exists('g:loaded_checksum') || &cp
  finish
endif
let g:loaded_checksum = 1

if v:version < '700'
  echoerr "checksum unavailable: requires Vim 7.0+"
  finish
endif

"moved to checksum#Calculate()
"if !executable('md5sum') && !executable('openssl')
  "echoerr "checksum: requires either md5sum or openssl"
  "finish
"endif

" Default configuration {{{1
if exists('g:checksum_clipboard')
  let g:checksum_clipboard = g:checksum_clipboard =~? 'none\|vim\|external\|all' ? tolower(g:checksum_clipboard) : 'all'
else
  let g:checksum_clipboard = 'all'
endif

if !exists('g:checksum_cmd')
    if executable('md5sum')
        let g:checksum_cmd = 'md5sum'
    elseif executable('openssl')
        let g:checksum_cmd = 'openssl md5 | awk "{print \$NF}"'
    endif
endif

if !exists('g:checksum_map') | let g:checksum_map = '<Leader>c' | endif

" Commands & Mappings {{{1
command! -nargs=0 -range=% Checksum call checksum#Calculate(<line1>,<line2>)

if !hasmapto('<Plug>Checksum')
    try
        exe "nmap <unique> " . g:checksum_map . " <Plug>Checksum"
        exe "xmap <unique> " . g:checksum_map . " <Plug>Checksum"
    catch /^Vim(.*):E227:/
        if(&verbose != 0)
            echohl WarningMsg|echomsg 'Error: checksum default mapping: ' . g:checksum_map
            \ . 'is already taken, refusing to overwrite it. See :h ChecksumConfig-map' |echohl None
        endif
    endtry
endif

nnoremap <unique> <script> <Plug>Checksum :Checksum<CR>
xnoremap <unique> <script> <Plug>Checksum :Checksum<CR>
