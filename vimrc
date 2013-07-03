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

" monitor realtime changes to a file
set autoread

" ------------------------------------------------
" Visual stuff
" ------------------------------------------------
" Status bar
" http://derekwyatt.org/vim/the-vimrc-file/my-vimrc-file 
" set stl=%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%c\ Buf:%n\ [%b][0x%B]
" set laststatus=2

if has('statusline')
    set statusline=%<%f\
    set statusline+=%w%h%m%r
    set statusline+=%{fugitive#statusline()}
    set statusline+=\ [%{&ff}/%Y]
    set statusline+=\ [%{getcwd()}]
    set statusline+=%=%-14.(Line:\ %l\ of\ %L\ [%p%%]\ -\ Col:\ %c%V%)
endif


" Disable all blinking:
set guicursor+=a:blinkon0
" Default color scheme
color neverness
" Whitespace stuff
set wrap
set tabstop=4
set shiftwidth=4
set softtabstop=4
set list listchars=tab:▸\ ,trail:¬
set showbreak=⌎

" Use par for text formatting
set formatprg=par

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

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
vmap <D-j> gj
vmap <D-k> gk
vmap <D-4> g$
vmap <D-6> g^
vmap <D-0> g^
nmap <D-j> gj
nmap <D-k> gk
nmap <D-4> g$
nmap <D-6> g^
nmap <D-0> g^

" Copy all text of current line, paste below and replace everything with =
nnoremap <leader>= yypVr=

" TextMate bolds and italics
let s:surround_{char2nr("b")} = "**\r**"
let s:surround_{char2nr("i")} = "*\r*"
" vmap <D-b> sb<cr>

" ------------------------------------------------
" Shortcuts
" ------------------------------------------------
nmap ,mm :% !/usr/local/bin/multimarkdown<cr>

" Quickly edit vimcr files
nmap ,evr :tabedit ~/.vimrc<cr>
nmap ,egr :tabedit ~/.gvimrc<cr>

" Server shortcuts
nmap ,dream :e sftp://zettt@ps34711.dreamhostps.com/<cr>

command! Marked silent !open -a "Marked.app" "%:p"
nmap ,marked :silent !open -a Marked.app '%:p'<cr>

" ------------------------------------------------
" Gundo
" ------------------------------------------------
nnoremap <F5> :GundoToggle<CR>

" ------------------------------------------------
" Functions and autocommands
" ------------------------------------------------
" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal g'\"" | endif
endif

au BufRead,BufNewFile *.spmd		set filetype=spmd
au BufRead,BufNewFile *.fountain	set filetype=spmd

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

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

" Causes linebreaking, rather than character breaking
" Unfortunately turns off displaying special characters like ¬
" at the end of lines
command! -nargs=* Wrap set wrap linebreak nolist

" make uses real tabs
au FileType make                                     set noexpandtab

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

au BufRead,BufNewFile *.txt call s:setupWrapping()

" make python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python  set tabstop=4 textwidth=79

" Save file when Vim loses focus
au BufLeave,FocusLost * silent! :wall

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
