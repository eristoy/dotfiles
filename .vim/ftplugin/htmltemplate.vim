" The htmlheader plugin 
" created by Linus Claußnitzer
" Version 1
" Copyright by Linus Claußnitzer
" Email: linus.vivaldi@gmail.com

call setline(1, '<!Doctype PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">')
call setline(2, '<html>')
call setline(3, '<head>')
call setline(4, '<title></title>')
call setline(5, '</head>')
call setline(6, '<body>')
call setline(7, '')
call setline(8, '</body>')
call setline(9, '</html>')

normal gg=G
