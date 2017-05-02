" ============================================================================
" File:        checksum.vim
" Description: vim global plugin to cryptographically checksum files
" Maintainer:  Javier Lopez <m@javier.io>
" ============================================================================

function! checksum#CopyToClipboard(clip) "{{{
  if g:checksum_clipboard == 'vim' || g:checksum_clipboard == 'all'
    call setreg('"', a:clip)
  endif
  if g:checksum_clipboard == 'external' || g:checksum_clipboard == 'all'
    if executable('xclip')
      call system('printf "' .  a:clip . '"' . ' | ' .
            \ 'xclip -selection clipboard; xclip -o -selection clipboard')
    elseif executable ('xsel')
      call system('printf "' .  a:clip . '"' . ' | ' .  'xsel -bi')
    elseif executable ('pbcopy')
      call system('printf "' .  a:clip . '"' . ' | ' .
            \ 'pbcopy')
    endif
    if has("win32") || has("win16")
      call setreg('*', a:clip)
    endif
  endif

  if exists('g:checksum_clipboard_cmd')
      call system('printf "' .  a:clip . '"' . ' | ' .  g:checksum_clipboard_cmd)
  endif
endfunction

function! checksum#GetVisualSelection()
  "why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  try
      let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
      let lines[0] = lines[0][col1 - 1:]
  catch /^Vim\%((\a\+)\)\=:E/
      return ''
  endtry
  return join(lines, "\n")
endfunction

function! checksum#Calculate(line1, line2)  "{{{
  if !exists('g:checksum_cmd')
    echoerr "checksum: requires either 'md5sum' or 'openssl'"
    return 1
  endif

  if a:line1 == 1 && a:line2 == line('$')
        let buffer = join(getline(a:line1, a:line2), "\n") . "\n"
  else
      let buffer = checksum#GetVisualSelection()
      if empty(buffer)
        let buffer = join(getline(a:line1, a:line2), "\n") . "\n"
      endif
  endif

  redraw | echon 'Calculating checksum ... '
  let l:checksum = system(g:checksum_cmd . ' | awk "{printf \"%s\", \$1}"', buffer)
  if empty(l:checksum)
        redraw | echohl WarningMsg|echomsg 'Error: unable to calculate the checksum using' . g:checksum_cmd | echohl None
  else
      call checksum#CopyToClipboard(l:checksum)
      redraw | echomsg 'Checksum: ' . l:checksum
      "echo buffer | echo a:line1 | echo a:line2 "help debugging
  endif
endfunction
