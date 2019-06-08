call plug#begin('~/.local/share/nvim/site/autoload')
Plug 'kassio/neoterm'
Plug 'vim-pandoc/vim-rmarkdown'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'ervandew/supertab'
call plug#end()

syntax on                      " Syntax highlighting; also does an implicit filetype on
filetype plugin indent on      " Enable detection, plugin , and indent for filetype
set backspace=indent,eol,start " This gets backspace to work in some situations
set mouse=                     " allow mouse usage
let mapleader=","              " re-map mapleader from \ to ,
set autoindent                 " maintain indentation from previous line
set smarttab                   " at the beginning of the line, insert spaces according to shiftwidth
set expandtab                  " spaces instead of tabs
set nu                         " show line numbers
set noswapfile                 " disable swap file creation
set nohls                      " disable highlighting searches

" Window navigation.
" ,w moves to the right (if terminal buffer, automatically enters insert mode
"   from the autocommand set up below in the neoterm settings
" ,q moves to the left
noremap <silent> ,w :wincmd l<cr>
noremap <silent> ,q :wincmd h<cr>

" The above mppings for ,w and ,q to move between windows requires being in
" Normal mode first. The following commands let you use Alt-w and Alt-q to
" switch -- even while in Insert mode.
noremap <M-w> <Esc>:wincmd l<CR>
tnoremap <M-q> <C-\><C-n>:wincmd h<CR>

" ----------------------------------------------------------------------------
" neoterm settings
" ----------------------------------------------------------------------------
" Open a terminal to the right (neoterm plugin)
nmap <Leader>t :vert rightb Tnew<CR>

" When in a terminal, by default Esc does not go back to normal mode and
" instead you need to use Ctrl-\ Ctrl-n. This remaps to use Esc.
tnoremap <Esc> <C-\><C-n>

" Any time a terminal is entered, go directly into Insert mode...
:au BufEnter,FocusGained,BufWinEnter,WinEnter * if &buftype == 'terminal' | :startinsert | endif

" ...and when leaving it, stop Insert mode
:au BufLeave,FocusLost,BufWinLeave,WinLeave * if &buftype == 'terminal' | :stopinsert | endif


" The above autocommand triggers a bug so we need a workaround.
"
" There's a Vim and NeoVim bug where terminal buffers don't respect the
" autocmd when using the mouse to enter a buffer. Based on the following
" comment in the neovim repo, the workaround is to disable left mouse release,
" specifically in the terminal buffer (!)
" https://github.com/neovim/neovim/issues/9483#issuecomment-461865773
tmap <LeftRelease> <Nop>


" Send text to open neoterm terminal (neoterm plugin)
nmap gx <Plug>(neoterm-repl-send)<CR>

" Send selection, and go to the terminal in insert mode
xmap gx <Plug>(neoterm-repl-send)`><CR>
nmap gxx <Plug>(neoterm-repl-send-line)<CR>

" Render the current RMarkdown file to HTML (named after the current file)
nmap <Leader>k :T rmarkdown::render("%")<CR>

" Have Neoterm scroll to the end of its buffer after running a command
let g:neoterm_autoscroll = 1

" Let the user determine what REPL to load
let g:neoterm_auto_repl_cmd = 0

" Send code chunk.
"
" When inside a code chunk, <Leader>cd selects the chunk and sends to neoterm.
" Breaking this down...
"
" /```{<CR>                       -> search for chunk delimiter (recall <CR> is Enter)
" N                               -> find the *previous* match to ```{
" j                               -> move down one line from the previous match
" V                               -> enter visual line-select mode
" /^```\n<CR>                     -> select until the next chunk delimiter by itself on the line (which should be the end)
" k                               -> go up one line from that match so we don't include that line
" <Plug>(neoterm-repl-send)<CR>   -> send the selection to the neoterm terminal
" /```{r<CR>                      -> go to the start of the next chunk
nmap <Leader>cd /```{<CR>NjV/```\n<CR>k<Plug>(neoterm-repl-send)<CR>/```{r<CR>

" ----------------------------------------------------------------------------
" vim-pandoc and vim-pandoc-syntax settings
" ----------------------------------------------------------------------------
" By default, keep spell-check off. Turn on with `set spell`
let g:pandoc#spell#enabled = 0

" Disable the conversion of ``` to lambda and other fancy
" concealment/conversion that ends up confusing me
let g:pandoc#syntax#conceal#use = 0

" Allow folding of RMarkdown code blocks
let g:pandoc#folding#fold_fenced_codeblocks = 1
