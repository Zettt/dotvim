
if has("gui_macvim")
    " Shift Key Movement
    let macvim_hig_shift_movement = 1

    " Fullscreen takes up entire screen
    set fuoptions=maxhorz,maxvert

    " Use my preferred font
    set guifont=Menlo:h11

    " Highlight current line
    set cursorline
    nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

    " Command-T for CommandT
    macmenu &File.New\ Tab key=<D-T>
    map <D-t> :CommandT<CR>
    imap <D-t> <Esc>:CommandT<CR>

    " Command-Return for fullscreen
    macmenu Window.Toggle\ Full\ Screen\ Mode key=<D-CR>

    " Command-Shift-F for Ack
    map <D-F> :Ack<space>

    " Command-e for ConqueTerm
    map <D-e> :call StartTerm()<CR>

    " Command-/ to toggle comments
    map <D-/> <plug>NERDCommenterToggle<CR>

    " Command-][ to increase/decrease indentation
    nmap <D-[> <<
    nmap <D-]> >>
    vmap <D-[> <gv
    vmap <D-]> >gv

    " ------------------------------------------------
    " Mappings
    " ------------------------------------------------

    " Map Command-# to switch tabs
    map  <D-0> 0gt
    imap <D-0> <Esc>0gt
    map  <D-1> 1gt
    imap <D-1> <Esc>1gt
    map  <D-2> 2gt
    imap <D-2> <Esc>2gt
    map  <D-3> 3gt
    imap <D-3> <Esc>3gt
    map  <D-4> 4gt
    imap <D-4> <Esc>4gt
    map  <D-5> 5gt
    imap <D-5> <Esc>5gt
    map  <D-6> 6gt
    imap <D-6> <Esc>6gt
    map  <D-7> 7gt
    imap <D-7> <Esc>7gt
    map  <D-8> 8gt
    imap <D-8> <Esc>8gt
    map  <D-9> 9gt
    imap <D-9> <Esc>9gt
endif

" Start without the toolbar
set guioptions-=T

" Default color scheme
color neverness

" ConqueTerm wrapper
function StartTerm()
    execute 'ConqueTerm ' . $SHELL . ' --login'
    setlocal listchars=tab:\ \ 
endfunction

" Project Tree
autocmd VimEnter * call s:CdIfDirectory(expand("<amatch>"))

" If the parameter is a directory, cd into it
function s:CdIfDirectory(directory)
    let explicitDirectory = isdirectory(a:directory)
    let directory = explicitDirectory || empty(a:directory)

    if explicitDirectory
        exe "cd " . fnameescape(a:directory)
    endif

    if explicitDirectory
        wincmd p
    endif
endfunction

" Utility functions to create file commands
function s:CommandCabbr(abbreviation, expansion)
    execute 'cabbrev ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction

function s:FileCommand(name, ...)
    if exists("a:1")
        let funcname = a:1
    else
        let funcname = a:name
    endif

    execute 'command -nargs=1 -complete=file ' . a:name . ' :call ' . funcname . '(<f-args>)'
endfunction

function s:DefineCommand(name, destination)
    call s:FileCommand(a:destination)
    call s:CommandCabbr(a:name, a:destination)
endfunction

function Touch(file)
    execute "!touch " . shellescape(a:file, 1)
endfunction

function Remove(file)
    let current_path = expand("%")
    let removed_path = fnamemodify(a:file, ":p")

    if (current_path == removed_path) && (getbufvar("%", "&modified"))
        echo "You are trying to remove the file you are editing. Please close the buffer first."
    else
        execute "!rm " . shellescape(a:file, 1)
    endif

    call s:UpdateNERDTree()
endfunction

function Mkdir(file)
    execute "!mkdir " . shellescape(a:file, 1)
    call s:UpdateNERDTree()
endfunction

"function Edit(file)
    "if exists("b:NERDTreeRoot")
        "wincmd p
    "endif

    "execute "e " . fnameescape(a:file)

    "ruby << RUBY
    "destination = File.expand_path(VIM.evaluate(%{system("dirname " . shellescape(a:file, 1))}))
    "pwd         = File.expand_path(Dir.pwd)
    "home        = pwd == File.expand_path("~")

    "if home || Regexp.new("^" + Regexp.escape(pwd)) !~ destination
        "VIM.command(%{call ChangeDirectory(system("dirname " . shellescape(a:file, 1)), 0)})
    "end
    "RUBY
"endfunction

