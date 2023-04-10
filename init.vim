call plug#begin('~/.local/share/nvim/site/autoload')
" vim-rmarkdown, vim-pandoc, vim-pandoc-syntax
" --------------------------------------------
" These three plugins jointly provide syntax highlighting for RMarkdown. This
" allows R chunks to be formatted as R code.
"
" See vim-pandoc config section below.
Plug 'vim-pandoc/vim-rmarkdown'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
" ToggleTerm
" ----------
" Easily interact with a terminal within vim.
"
" This opens a terminal and allows you to send lines to it. Very useful for
" interactive Python and R work. See below ToggleTerm config for keymappings
" configured here, but briefly:
"
"   Use ,t to open a terminal to the right
"   Use ,w in normal mode to jump to the terminal
"   Use ,q in terminal to jump back to text buffer
"   Use ,gx on a selection to send it to the terminal
"   Use ,gxx on a line to send it to the terminal
"   Use ,cd to send an RMarkdown code chunk to the terminal (which is expected
"   to be running an R interpreter)
"
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
call plug#end()

" Syntax highlighting; also does an implicit filetype on
syntax on
" Enable detection, plugin , and indent for filetype
filetype plugin indent on

" ,h ,j ,k and ,l to navigate windows
noremap <silent> ,h :wincmd h<cr>
noremap <silent> ,j :wincmd j<cr>
noremap <silent> ,k :wincmd k<cr>
noremap <silent> ,l :wincmd l<cr>
" ,q and ,w move to left and right windows respectively. Useful when working
" with a terminal. ,q will go back to text buffer even in insert mode in
" a terminal buffer. Can be more ergonomic than ,h and ,l defined above.
noremap <silent> ,w :wincmd l<cr>
noremap <silent> ,q :wincmd h<cr>
tnoremap <silent> ,q <C-\><C-n>:wincmd h<cr>


" ----------------------------------------------------------------------------
" ----------------------------------------------------------------------------
" ToggleTerm
" ----------------------------------------------------------------------------
" ,t to open a terminal to the right (ToggleTerm)
nmap <leader>t :ToggleTerm direction=vertical<CR>

" When in a terminal, by default Esc does not go back to normal mode and
" instead you need to use Ctrl-\ Ctrl-n. That's pretty awkward; this remaps to
" use Esc.
tnoremap <Esc> <C-\><C-n>

" ,gxx to send current line to terminal
nmap gxx :ToggleTermSendCurrentLine<CR><CR>

" ,gx to send current selection (line or visual) to terminal
xmap gx :ToggleTermSendVisualSelection<CR><CR>

" ,k to render the current RMarkdown file to HTML (named after the current file)
:autocmd FileType rmarkdown nmap <leader>k :TermExec cmd='rmarkdown::render("%:p")'<CR>

" ,k to run the file in IPython when working in Python.
:autocmd FileType python nmap <leader>k :TermExec cmd='run %:p'<CR>

" ,cd to send RMarkdown code chunk and move to the next one.
"
" Breaking this down...
"
" /```{<CR>                                 -> search for chunk delimiter (recall <CR> is Enter)
" N                                         -> find the *previous* match to ```{
" j                                         -> move down one line from the previous match
" V                                         -> enter visual line-select mode
" /^```\n<CR>                               -> select until the next chunk delimiter by itself on the line (which should be the end)
" k                                         -> go up one line from that match so we don't include that line
" <Esc>:ToggleTermSendVisualSelection<CR>   -> send the selection to the terminal
" /```{r<CR>                                -> go to the start of the next chunk
nmap <leader>cd /```{<CR>NjV/```\n<CR>k<Esc>:ToggleTermSendVisualSelection<CR>/```{r<CR>

" ,yr to add commonly-used YAML front matter to RMarkdown documents. Mnemonic is
" 'YAML for RMarkdown'. It adds this:
"
" ---
" output:
"   html_document:
"     code_folding: hide
"     toc: true
"     toc_float: true
"     toc_depth: 3
" ---
"
nmap <leader>yr i---<CR>output:<CR>  html_document:<CR>  code_folding: hide<CR>toc: true<CR>toc_float: true<CR>toc_depth: 3<CR><BS>---<Esc>0

" ,ko to insert a knitr global options chunk. Mnemonic is 'knitr options'
nmap <leader>ko i<CR>```{r}<CR>knitr::opts_chunk$set(warning=FALSE, message=FALSE)<CR>```<CR><Esc>0



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
