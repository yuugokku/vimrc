if &compatible
    set nocompatible
endif
set encoding=utf-8
scriptencoding utf-8
let g:is_win32_unix = has('win32unix')
let g:is_win32 = has('win32')

" ----------
" basic settings
" ----------
" key mapping -------------------------- {{{
let g:mapleader = " "
nnoremap <Leader>v :vs $MYVIMRC<CR>
" awesome mode changing
inoremap jk <ESC>
" select them
nnoremap <C-a> ggVG
vnoremap <C-a> <Esc>ggVG
" useful for completion
inoremap <C-j> <Down>
inoremap <C-k> <Up>
" surrounding
nnoremap <Leader>" viw<Esc>a"<Esc>bi"<Esc>el
nnoremap <Leader>' viw<Esc>a'<Esc>bi'<Esc>el
nnoremap <Leader>( viw<Esc>a)<Esc>bi(<Esc>el
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

" sometimes mistype a command
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>

nnoremap <C-n> :set nohlsearch<CR>

" detect whitespace
nnoremap <Leader>w :match Error /\v +$/<CR>
nnoremap <Leader>W :match none<CR>
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
set laststatus=2
set hidden
set updatetime=400
set nowritebackup
set shiftwidth=4 tabstop=4 expandtab autoindent
set nowrap
set history=2000
set noswapfile nobackup noundofile
set termguicolors
set wildmenu
set statusline=*%f\ %m\ -\ FileType:\ %y\ %=%l/%L\ Lines
set belloff=esc,error
set backspace=indent,eol,nostop
set clipboard=unnamed
" }}}

" Auto commands specific to FileType ----------- {{{

" vimscript
augroup filetype_vim
    autocmd! *
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" markdown
augroup filetype_markdown
    autocmd! *
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown onoremap <buffer>ih :<C-u>execute "normal! ?^#\\+\r:nohlsearch\rwvg_"<CR>
    autocmd FileType markdown onoremap <buffer>ah :<C-u>execute "normal! ?^#\\+\r:nohlsearch\r0vg_"<CR>
    " hyperlinking quickly
    autocmd FileType markdown vnoremap <buffer><C-l> "kc[]()<Esc>hhh"kpf(a
    autocmd FileType markdown vnoremap <buffer><C-p> "kc[]()<Esc>h"kpF[a
augroup END

" python
augroup filetype_python
    autocmd! *
    autocmd FileType python inoremap <buffer>"""<Tab> """<CR>"""<Esc>ko
augroup END

" javascript
augroup filetype_javascript
    autocmd! *
    autocmd FileType javascript inoremap <buffer>{<CR> {}<Left><CR><Esc>O
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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rust-lang/rust.vim'
Plug 'lambdalisue/fern.vim'
Plug 'twitvim/twitvim'
Plug 'morhetz/gruvbox'
Plug 'vim-jp/vimdoc-ja'
Plug 'tpope/vim-fugitive'
Plug 'uguu-org/vim-matrix-screensaver'
Plug 'goerz/jupytext.vim'

call plug#end()

" }}}

" ----------
" plugin-related settings
" ----------
" twitvim ----------------------------------------- {{{
" Make sure some common commands about twitvim starts with <C-t>
nnoremap <C-t>tl :FriendsTwitter<CR>
nnoremap <C-t>p :ProfileTwitter<CR>
nnoremap <C-t>n :MentionsTwitter<CR>
nnoremap <C-t>sw :SwitchLoginTwitter<CR>
nnoremap <buffer><C-t>j :PosttoTwitter<CR>
nnoremap <buffer><C-t>h :PreviousTwitter<CR>
nnoremap <buffer><C-t>l :NextTwitter<CR>

" configure the number of tweets returned by :FriendsTwitter
let twitvim_count = 100
" default browser
if g:is_win32
    let g:twitvim_browser_cmd = ''
else 
    let g:twitvim_browser_cmd = 'firefox'
endif
" }}}

" rust.vim
let g:rustfmt_autosave = 1

" japanese document
set helplang=ja,en

" Fern.vim ---------------------------------- {{{
nmap <Plug>(fern-action-reload) <Plug>(fern-action-reload:all)

nmap <Leader>f :Fern -drawer .<CR>

function! s:set_fernkeys() abort
    nmap <buffer>fo <Plug>(fern-action-open:vsplit)
    nmap <buffer>fn <Plug>(fern-action-new-file)<Plug>(fern-action-reload)
    nmap <buffer>fd <Plug>(fern-action-new-dir)<Plug>(fern-action-reload)
    nmap <buffer>fc <Plug>(fern-action-copy)<Plug>(fern-action-reload)
    nmap <buffer>fm <Plug>(fern-action-move)<Plug>(fern-action-reload)
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

augroup my-fern
    autocmd! *
    autocmd FileType fern call s:set_fernkeys()
augroup END

let g:fern#default_hidden=1
" }}}

" Coc.nvim installation and settings -------------------- {{{
let g:coc_global_extensions = [
            \'coc-rust-analyzer',
            \'coc-pyright',
            \'coc-html',
            \'coc-css',
            \'coc-json',
            \'coc-tsserver',
            \]

if g:is_win32_unix
    let g:coc_node_path = expand('/c/nodejs/node.exe')
else
    let g:coc_node_path = 'node'
endif

nmap <Leader>def <Plug>(coc-definition)

" }}}

" colorscheme: gruvbox -------------------{{{
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'soft'
" }}}

" jupytext.vim ------------------ {{{
if is_win32
    let g:jupytext_command = expand('~/anaconda3/Scripts/jupytext')
endif
let g:jupytext_fmt = 'py'
" }}}
