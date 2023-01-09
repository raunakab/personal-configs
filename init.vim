let g:python3_host_prog = "/usr/local/bin/python3.9"

set noendofline
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching
set ignorecase              " case insensitive
set mouse=v                 " middle-click paste with
set hlsearch                " highlight search
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindent
set autoindent              " indent a new line the same amount as the line just typed
set foldmethod=indent
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=80                  " set an 80 column border for good coding style
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
"set spell                 " enable spell check (may need to download language package)
"set noswapfile            " disable creating swap file
"set backupdir=~/.cache/vim " Directory to store backup files.s

call plug#begin()
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'sainnhe/sonokai'
    "Plug 'morhetz/gruvbox'
    "Plug 'sainnhe/everforest'
    "Plug 'dracula/vim'
    "Plug 'ryanoasis/vim-devicons'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'scrooloose/nerdtree'
    Plug 'preservim/nerdcommenter'
    Plug 'mhinz/vim-startify'
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    Plug 'EdenEast/nightfox.nvim'
call plug#end()

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
"let g:airline#extensions#tabline#right_sep = '>'
"let g:airline#extensions#tabline#left_alt_sep = '>'
let g:airline_theme = 'onedark'
set showtabline=2
"set noshowmode
let g:airline#extensions#tabline#formatter = 'default'

let g:webdevicons_enable = 1
let g:webdevicons_enable_denite = 1

" open NERDTree on the right side
let g:NERDTreeWinPos = "right"

" color schemes
syntax enable

colorscheme sonokai
"colorscheme everforest
"colorscheme dracula
"colorscheme gruvbox

" open new split panes to right and below
set splitright
set splitbelow

" Custum key mappings
nnoremap L $
nnoremap H ^
nnoremap f %
nnoremap o o<esc>
nnoremap O O<esc>
nnoremap <Leader>w <C-w>
nnoremap <Leader><space> :NERDTreeToggle<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
nmap <Leader>do <Plug>(coc-codeaction)
nmap <Leader>rn <Plug>(coc-rename)

vnoremap L $
vnoremap H ^
vnoremap f %
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
vnoremap <Leader>b :NERDTreeToggle<CR>

onoremap L $
onoremap H ^
onoremap f %
onoremap o o<esc>
onoremap O O<esc>


let s:monkey_terminal_window = -1
let s:monkey_terminal_buffer = -1
let s:monkey_terminal_job_id = -1

function! MonkeyTerminalOpen()
    " Check if buffer exists, if not create a window and a buffer
    if !bufexists(s:monkey_terminal_buffer)
        " Creates a window call monkey_terminal
        new monkey_terminal
        " Moves to the window the right the current one
        wincmd L
        let s:monkey_terminal_job_id = termopen($SHELL, { 'detach': 1 })

        " Change the name of the buffer to "Terminal 1"
        silent file Terminal\ 1
        " Gets the id of the terminal window
        let s:monkey_terminal_window = win_getid()
        let s:monkey_terminal_buffer = bufnr('%')

        " The buffer of the terminal won't appear in the list of the buffers
        " when calling :buffers command
        set nobuflisted
    else
        if !win_gotoid(s:monkey_terminal_window)
            sp
            " Moves to the window below the current one
            wincmd L   
            buffer Terminal\ 1
            " Gets the id of the terminal window
             let s:monkey_terminal_window =win_getid()
        endif
    endif
endfunction

function! MonkeyTerminalToggle()
    if win_gotoid(s:monkey_terminal_window)
        call MonkeyTerminalClose()
    else
        call MonkeyTerminalOpen()
    endif
endfunction

function! MonkeyTerminalClose()
    if win_gotoid(s:monkey_terminal_window)
        " close the current window
        hide
    endif
endfunction

function! MonkeyTerminalExec(cmd)
    if !win_gotoid(s:monkey_terminal_window)
        call MonkeyTerminalOpen()
    endif

    " clear current input
    call jobsend(s:monkey_terminal_job_id, "clear\n")

    " run cmd
    call jobsend(s:monkey_terminal_job_id, a:cmd . "\n")
    normal! G
    wincmd p
endfunction

" With this maps you can now toggle the terminal
"nnoremap <F7> :call MonkeyTerminalToggle()<cr>
nnoremap <Leader>- :call MonkeyTerminalToggle()<cr>
"tnoremap <F7> <C-\><C-n>:call MonkeyTerminalToggle()<cr>

" This an example on how specify command with different types of files.
augroup go
    autocmd!
    autocmd BufRead,BufNewFile *.go set filetype=go
    autocmd FileType go nnoremap <F5> :call MonkeyTerminalExec('go run ' . expand('%'))<cr>
augroup END 




 "Toggle 'default' terminal
"nnoremap <M-`> :call ChooseTerm("term-slider", 1)<CR>
"nnoremap <Leader>- :call ChooseTerm("term-slider", 1)<CR>
 "Start terminal in current pane
"nnoremap <M-CR> :call ChooseTerm("term-pane", 0)<CR>
"nnoremap <Leader>M :call ChooseTerm("term-pane", 0)<CR>
 
"function! ChooseTerm(termname, slider)
    "let pane = bufwinnr(a:termname)
    "let buf = bufexists(a:termname)
    "if pane > 0
         "pane is visible
        "if a:slider > 0
            ":exe pane . "wincmd c"
        "else
            ":exe "e #" 
        "endif
    "elseif buf > 0
         "buffer is not in pane
        "if a:slider
            ":exe "topleft split"
        "endif
        ":exe "buffer " . a:termname
    "else
         "buffer is not loaded, create
        "if a:slider
            ":exe "topleft split"
        "endif
        ":terminal
        ":exe "f " a:termname
    "endif
"endfunction
