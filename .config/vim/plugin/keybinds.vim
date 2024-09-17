if has('clipboard')
	if has("win32")
		noremap <Leader>y "*y
		noremap <Leader>p "*p
	else
		if has("unix")
			let s:uname = system("uname")
			if s:uname == "Darwin\n"

			else
				noremap <Leader>Y "+y
				noremap <Leader>P "+p
			endif
		endif
	endif
endif
nmap <Leader>\ :vsplit<CR>
nmap <Leader>- :split<CR>

nnoremap <Leader><Leader>r :%s//g<Left><Left>
xnoremap <Leader><Leader>r :s//g<Left><Left>

vnoremap J :m '>+1<CR>
" xnoremap K :m '<-2<CR>
vnoremap K :m '<-2<CR>

" Put search results in the middle of the screen
nnoremap n nzz
nnoremap N Nzz

" Optional (so <CR> cancels prefix, selection, operator).
nnoremap <CR> <Esc>
vnoremap <CR> <Esc>gV
onoremap <CR> <Esc>


noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <esc> <nop>
inoremap jk <esc>

tnoremap <Leader><Esc> <C-\><c-n>
tnoremap <A-k> <C-\><C-n>:wincnd k<CR>
tnoremap <A-j> <C-\><C-n>:wincmd j<CR>
tnoremap <A-h> <C-\><C-n>:wincmd h<CR>
tnoremap <A-l> <C-\><C-n>:wincmd l<CR>
nmap <silent> <A-k> :wincmd k<CR>
nmap <silent> <A-j> :wincmd j<CR>
nmap <silent> <A-h> :wincmd h<CR>
nmap <silent> <A-l> :wincmd l<CR>
nmap <silent> <A-C-j> :resize -1<CR>
nmap <silent> <A-C-h> :vertical-resize -1<CR>
nmap <silent> <A-C-l> :vertical-resize +1<CR>
nmap <silent> <A-C-k> :resize +1<CR>
nmap <silent> <A-e> :tabnext<CR>
nmap <silent> <A-q> :tabprevious<CR>
