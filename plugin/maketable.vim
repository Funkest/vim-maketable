function! s:makeTable(bang, line1, line2)
  let max = 0
  let rows = map(map(range(a:line1, a:line2), 'getline(v:val)'), 'split(v:val, ",")')
  let w = []
  for row in rows
    let ncol = len(row)
    if ncol > max
      let max = ncol
    endif
  endfor
  for n in range(len(rows))
    let rows[n] += repeat([""], max - len(rows[n]))
  endfor
  let h = range(len(rows[0]))
  for c in range(len(rows[0]))
    let m = 0
    let w = range(len(rows))
    for r in range(len(w))
      let w[r] = strdisplaywidth(rows[r][c])
      let m = max([m, w[r]])
    endfor
    for r in range(len(w))
      let rows[r][c] = rows[r][c] . repeat(' ', m - w[r])
    endfor
    let h[c] = repeat('-', strdisplaywidth(rows[0][c]))
  endfor
  for n in range(len(rows))
    let rows[n] = '|' . join(rows[n], '|') . '|'
  endfor
  exe printf('%d,%dd _', a:line1, a:line2)
  if a:bang =~ '!'
    call insert(rows, '|' . join(h, '|') . '|', 1)
  else
    call insert(rows, '|' . join(h, '|') . '|', 0)
    call insert(rows, '|' . substitute(join(h, '|'), '-', ' ', 'g') . '|', 0)
  endif
  call setline(a:line1, rows)
endfunction

command! -bang -range MakeTable call s:makeTable("<bang>", <line1>, <line2>)