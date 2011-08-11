" Add the following lines to your ~/.vimrc to enable online documentation
" Inspiration: http://vim.wikia.com/wiki/Online_documentation_for_word_under_cursor

function Browser()
	if has("win32") || has("win64")
		let s:browser = "C:\\Program Files\\Mozilla Firefox\\firefox.exe -new-tab"
" Cygwin
	elseif has("win32unix") 
		let s:browser = "'/cygdrive/c/Program\ Files/Mozilla\ Firefox/firefox.exe' -new-tab"
	elseif has("mac") || has("macunix") || has("unix")
		let s:browser = "firefox -new-tab"
	endif

	return s:browser
endfunction

function Run(command)
	if has("win32") || has("win64")
		let s:startCommand = "!start"
		let s:endCommand = ""
" TODO Untested on Mac
	elseif has("mac") || has("macunix") 
		let s:startCommand = "!open -a"
		let s:endCommand = ""
	elseif has("unix") || has("win32unix")
		let s:startCommand = "!"
		let s:endCommand = "&"
	else
		echo "Don't know how to handle this OS!"
		finish
	endif

	let s:cmd = "silent " . s:startCommand . " " . a:command . " " . s:endCommand
" echo s:cmd
	execute s:cmd
endfunction

function OnlineDoc()
	if &filetype == "viki"
" Dictionary
		let s:urlTemplate = "http://dictionary.reference.com/browse/<name>"
	elseif &filetype == "perl"
		let s:urlTemplate = "http://perldoc.perl.org/functions/<name>.html"
	elseif &filetype == "python"
		let s:urlTemplate = "http://www.google.com/search?q=<name>&domains=docs.python.org&sitesearch=docs.python.org"
	elseif &filetype == "ruby"
		let s:urlTemplate = "http://www.ruby-doc.org/core/classes/<name>.html"
	elseif &filetype == "vim"
		let s:urlTemplate = "http://vimdoc.sourceforge.net/search.php?search=<name>&docs=help"
	endif

	let s:wordUnderCursor = expand("<cword>")
	let s:url = substitute(s:urlTemplate, '<name>', s:wordUnderCursor, 'g')

	call Run(Browser() . " " . s:url)
endfunction

noremap <silent> <M-d> :call OnlineDoc()<CR>
inoremap <silent> <M-d> <Esc>:call OnlineDoc()<CR>a
