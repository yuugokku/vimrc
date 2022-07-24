" ----------
" basic settings
" ----------
" platform and encoding -------------------------{{{
if &compatible
    set nocompatible
endif

set t_u7=
set t_RV=
set encoding=utf-8
set termencoding=utf-8
scriptencoding utf-8
let g:is_win32_unix = has('win32unix')
let g:is_win32 = has('win32')
" }}}
" key mapping -------------------------- {{{
let g:mapleader = " "
nnoremap <Leader>v :vs $MYVIMRC<CR>
" awesome mode changing
inoremap jk <ESC>
" select them
nnoremap <C-a> ggVG
vnoremap <C-a> <Esc>ggVG
" nervous at splitting
nnoremap -h <C-w><
nnoremap -j <C-w>+
nnoremap -k <C-w>-
nnoremap -l <C-w>>
nnoremap -H 50<C-w><
nnoremap -J 10<C-w>+
nnoremap -K 10<C-w>-
nnoremap -L 50<C-w>>
" jumping across windows
nnoremap <Leader>h <C-w>h
nnoremap <Leader>l <C-w>l
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
" easily moving windows
nnoremap <Leader>H <C-w>H
nnoremap <Leader>L <C-w>L
nnoremap <Leader>J <C-w>J
nnoremap <Leader>K <C-w>K

" quick saving
nnoremap <Leader><Leader> :wa<CR>

nnoremap <C-n> :nohlsearch<CR>

onoremap ( [(
onoremap ) ])
vnoremap ( [(
vnoremap ) ])

" detect whitespace
nnoremap <Leader>w :match Error /\v +$/<CR>
nnoremap <Leader>W :match none<CR>

" terminal mode
tnoremap <Leader><Leader> <C-w>
tnoremap <c-k> <c-w>N
" }}}

" basic settings ----------------------- {{{
syntax enable
filetype plugin indent on
set number
set relativenumber
set incsearch
set hlsearch
if is_win32
    set nocursorline
else
    set cursorline
endif
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
set laststatus=2
set hidden
set updatetime=400
set nowritebackup
set shiftwidth=4 tabstop=4 expandtab autoindent
set nowrap
set history=2000
set noswapfile nobackup noundofile
set wildmenu
set statusline+=;\ %f\ %m\ -\ FileType:\ %y
set statusline+=%=Buffer:\ %n\ -\ %l/%L\ Lines\ %v
set belloff=esc,error
set backspace=indent,eol,nostop
set clipboard=unnamed
if has('python3/dyn')
    set pythonthreedll=python39
endif


" macros
let @n = 'gqip}j'
let @o = 'ojgqip{dd}j'
" }}}

" file specific settings -----------------{{{
" detect txt file as markdown
augroup filetype_txt
    autocmd! *
    autocmd FileType text setlocal filetype=markdown
augroup END

" vimscript
augroup filetype_vim
    autocmd! *
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" python
augroup filetype_python
    autocmd! *
augroup END

" javascript
augroup filetype_javascript
    autocmd! *
    autocmd FileType javascript inoremap <buffer>{<CR> {}<Left><CR><Esc>O
augroup END

" rust
augroup filetype_rust
    autocmd! *
    autocmd FileType rust inoremap <buffer>{<CR> {}<Left><CR><Esc>O
augroup END
" }}}

" ----------
" user-commands
" ---------- {{{

function s:convertToUTF8(encoding) abort
    execute 'e ++encoding=' . a:encoding
    execute 'set fileencoding=utf-8'
    execute 'write'
endfunction

command! -nargs=1 ConvertToUTF8 call s:convertToUTF8("<args>")
" }}}

" ----------
" vim-plug settings
" ----------

" automatic installation of vim-plug ------------------ {{{
" vim setting directory
function! s:get_vimdir() abort
    if g:is_win32
        return '~/vimfiles'
    else
        return '~/.vim'
    endif
endfunction

" vim-plug automatic installation
let s:vimplug_dir = expand(s:get_vimdir() . '/autoload')
let s:vimplug_target = expand(s:vimplug_dir . '/plug.vim')

if empty(glob(s:vimplug_target))
    silent execute '!curl -fLo ' . s:vimplug_target 
                \. ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

augroup vimplug_startup
    autocmd! *
    autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
                \| PlugInstall --sync | source $MYVIMRC
                \| endif
augroup END

" }}}

" plugins installation ------------------------- {{{
" plugins repository
let s:vimplug_repo = expand(s:get_vimdir() . '/plugins')

" installation
call plug#begin(s:vimplug_repo)

Plug 'junegunn/vim-plug'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'rust-lang/rust.vim'
Plug 'lambdalisue/fern.vim'
Plug 'morhetz/gruvbox'
Plug 'vim-jp/vimdoc-ja'
Plug 'tpope/vim-fugitive'
Plug 'yuugokku/yuugokku.vim'
Plug 'jalvesaq/Nvim-R'
Plug 'mattn/vim-maketable'
Plug 'thinca/vim-quickrun'
Plug 'pangloss/vim-javascript'
Plug 'vimwiki/vimwiki'
Plug 'tomasr/molokai'
Plug 'eigenfoo/stan-vim'
Plug 'jpalardy/vim-slime', { 'for': 'python' }
Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }
Plug 'ajpaulson/julia-syntax.vim'

call plug#end()

" }}}

" ----------
" plugin-related settings
" ----------

" japanese document
set helplang=ja,en

" Fern.vim ---------------------------------- {{{
nmap <Plug>(fern-action-reload) <Plug>(fern-action-reload:all)

nnoremap <Leader>f :Fern . -drawer<CR>

function! s:setFernKeys() abort
    " Open the file
    nmap <buffer>fo <Plug>(fern-action-open:vsplit)
    nmap <buffer>fs <Plug>(fern-action-open:split)
    nmap <buffer>ft <Plug>(fern-action-open:tabedit)
    " Create a file
    nmap <buffer>fn <Plug>(fern-action-new-file)<Plug>(fern-action-reload)
    " Create a directory
    nmap <buffer>fdir <Plug>(fern-action-new-dir)<Plug>(fern-action-reload)
    " Copy
    nmap <buffer>fc <Plug>(fern-action-copy)<Plug>(fern-action-reload)
    " Move
    nmap <buffer>fm <Plug>(fern-action-move)<Plug>(fern-action-reload)
    " Delete
    nmap <buffer>fdel <Plug>(fern-action-trash)<Plug>(fern-action-reload)
    nmap <buffer>frn <Plug>(fern-action-rename)<Plug>(fern-action-reload)
    nmap <buffer>frl <Plug>(fern-action-reload)

    nnoremap <buffer> -h <C-w><
    nnoremap <buffer> -j <C-w>+
    nnoremap <buffer> -k <C-w>-
    nnoremap <buffer> -l <C-w>>
    nnoremap <buffer> -H 50<C-w><
    nnoremap <buffer> -J 10<C-w>+
    nnoremap <buffer> -K 10<C-w>-
    nnoremap <buffer> -L 50<C-w>>
endfunction

augroup my_fern
    autocmd! *
    autocmd FileType fern call s:setFernKeys()
augroup END

let g:fern#default_hidden = 1
let g:fern#disable_drawer_smart = 1
" }}}

" colorscheme: gruvbox, molokai -------------------{{{
"colorscheme gruvbox
"set background=dark
if !empty(s:vimplug_repo . '/molokai')
    colorscheme molokai
endif
" }}}

" Nvim-R --------------------------------------------{{{
let R_auto_start = 1
let R_assign = 0

" }}}

" vim-slime / vim-ipython-cell ----------------------------------{{{

" Send to vimterminal
let g:slime_target = "vimterminal"

" default shell
let g:myshell = &shell

" Define cell delimiter
let g:slime_cell_delimiter = "# %%"
let g:ipython_bufnr = 0

" Setting up IPython window
function! s:setIPython() abort
    echom 'Launching IPython'
    let g:ipython_bufnr = term_start(g:myshell, {"vertical": 1})
    let g:slime_default_config = {"bufnr": g:ipython_bufnr}
    let g:slime_dont_ask_default = 1
    SlimeSend1 ipython --matplotlib
endfunction

function! s:quitIPython() abort
    if g:ipython_bufnr == 0
        echom 'Not yet started IPython'
        return
    endif
    echom 'Quitting IPython'
    call term_sendkeys(g:ipython_bufnr, "quit()\n")
    call term_wait(g:ipython_bufnr)
    call term_sendkeys(g:ipython_bufnr, "exit\r\n")
    let g:ipython_bufnr = 0
endfunction

augroup ipython_setup
    autocmd! *
    autocmd FileType python let localleader = "\\"
    autocmd FileType python nnoremap <buffer><localleader>rf :<c-u>call <SID>setIPython()<CR>
    autocmd FileType python nnoremap <buffer><localleader>rq :<c-u>call <SID>quitIPython()<CR>

    let g:slime_no_mappings = 1
    autocmd FileType python nnoremap <buffer><Plug>IPythonSendCR :<c-u>call term_sendkeys(g:ipython_bufnr, "\n")<CR>
    autocmd FileType python nnoremap <buffer><Plug>IPythonNextParagraph :<c-u>execute 'normal! }'<CR>
    autocmd FileType python nnoremap <buffer><Plug>IPythonNextLine :<c-u>execute 'normal! j'<CR>
    autocmd FileType python nnoremap <buffer><Plug>IPythonNextCell :<c-u>execute "normal! /^" . g:slime_cell_delimiter . "\r:nohlsearch\r"<CR>j

    autocmd FileType python nmap <buffer><c-c><c-p> <Plug>SlimeParagraphSend<Plug>IPythonSendCR<Plug>IPythonNextParagraph
    autocmd FileType python nmap <buffer><c-c><c-l> <Plug>SlimeLineSend<Plug>IPythonSendCR<Plug>IPythonNextLine
    autocmd FileType python nmap <buffer><c-c><c-c> <Plug>SlimeSendCell<Plug>IPythonSendCR<Plug>IPythonNextCell
augroup END

" }}}
