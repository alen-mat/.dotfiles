if has('filetype')
  set autoindent
  filetype indent plugin on
endif

if has('syntax')
  syntax on
endif

if has('mouse')
  set mouse=a
endif

" Display all matching files when tab-complete
set wildmenu
" - find by partial match
" - * fuzzy search
" - :b autocomplete open buffers

set showcmd
set hlsearch
set ignorecase
set smartcase
set nostartofline
set ruler
set laststatus=2
set confirm
set visualbell
set cmdheight=2
set number

"FINDING FILES
"Search through sub folders
"Tab-completion for file related tasks
set path+=**

" TAG JUMPING
" - requires ctags
" - ^] tag under cursor
" - g^] ambiguous tag
" - ^t back to tag stack
" - Not visual  
command! MakeTags !ctags -R .

"AUTOCOMPLETE
" - ^n for suggestion ^p to traverse suggestion
" - ^x^n only from current file
" - ^x^f for filenames
" - ^x^] for tags only
" - ^n autocomplete from default completion
"

"FILE BOWSING
" - 
"

"SNIPPETS
" noremap ,html : -lread <__FILE__><CR>3jwf>a
" - <CR> carriage return code of vim
"
command FileSyn execute "vnew | r !file_sync # "
command FormatJSON execute "%!json_pp"
"BUILD INTEGRATION
"set makeprg= <__COMMAND__>

"set background=dark     " background color (light|dark)
"call plug#begin('~/.vim/plugged')
"Plug 'glepnir/oceanic-material'
"call plug#end()
"colorscheme oceanic_material
