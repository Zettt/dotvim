" pathogen IMPORTANT!!!
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

set virtualedit=all
set foldenable

set nocompatible

set number
set ruler
syntax on

" Set encoding
set encoding=utf-8

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc


" ------------------------------------------------
" Visual stuff
" ------------------------------------------------
" Status bar
" http://derekwyatt.org/vim/the-vimrc-file/my-vimrc-file 
set stl=%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%c\ Buf:%n\ [%b][0x%B]
set laststatus=2
" Disable all blinking:
set guicursor+=a:blinkon0
" Default color scheme
color neverness
" Whitespace stuff
set wrap
set tabstop=4
set shiftwidth=4
set softtabstop=4
set list listchars=tab:▸\ ,trail:·

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

" ------------------------------------------------
" NERDTree stuff -
" ------------------------------------------------
" NERDTree configuration
let NERDTreeIgnore=['\.rbc$', '\~$']
map <Leader>n :NERDTreeToggle<CR>
" Shortcut for NERDTreeToggle
nmap ,nt :NERDTreeToggle<cr>
" Show hidden files in NERDTree
let NERDTreeShowHidden=1 

" ------------------------------------------------
" Command-T configuration
" ------------------------------------------------
let g:CommandTMaxHeight=20

" ------------------------------------------------
" ZoomWin configuration
" ------------------------------------------------
map <Leader><Leader> :ZoomWin<CR>

" ------------------------------------------------
" CTags
" ------------------------------------------------
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>

" ------------------------------------------------
" Mappings
" ------------------------------------------------
" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Unimpaired configuration
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Better scrolling for soft wrapped text
map j gj
map k gk
map <Up> gk
map <Down> gj

" ------------------------------------------------
" Shortcuts
" ------------------------------------------------
nmap ,mm :% !~/Library/Application\ Support/MultiMarkdown/bin/MultiMarkdown.pl<cr>

" Quickly edit vimcr files
nmap ,evr :tabedit ~/.vimrc<cr>
nmap ,egr :tabedit ~/.gvimrc<cr>

" Server shortcuts
nmap ,dreamhost :e sftp://zettt@ps34711.dreamhostps.com/<cr>

" ------------------------------------------------
" Functions and autocommands
" ------------------------------------------------
" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal g'\"" | endif
endif

function s:setupWrapping()
  set wrap
  " set wm=2
  " set textwidth=72
endfunction

function s:setupMarkup()
  set ft=markdown
  call s:setupWrapping()
  map <buffer> <Leader>p :Mm <CR>
endfunction

" Automatically align stuff
" https://gist.github.com/287147
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" Align text non automatically but with more characters...until I figured out
" how I need to modify the above lines...
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<cr>
  vmap <Leader>a= :Tabularize /=<cr>
  nmap <Leader>a| :Tabularize /|<cr>
  vmap <Leader>a| :Tabularize /|<cr>
  nmap <Leader>a: :Tabularize /:\zs<cr>
  vmap <Leader>a: :Tabularize /:\zs<cr>
end if

" make uses real tabs
au FileType make                                     set noexpandtab

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

au BufRead,BufNewFile *.txt call s:setupWrapping()

" make python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python  set tabstop=4 textwidth=79

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Automatically change current directory to that of the file in the buffer
autocmd BufEnter * cd %:p:h 

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_warnings=1

" Use modeline overrides
set modeline
set modelines=10

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1

" Should I ever need to print anything again. Here are some 
" useful settings
" set printfont=Menlo:h8:
" set printoptions=syntax:y
" set printoptions=header:0      

" Just so that I have this nifty functionality for future references
" Include user's local vim config
" if filereadable(expand("~/.vimrc.local"))
"   source ~/.vimrc.local
" endif
