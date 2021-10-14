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

" Auto commands specific to FileType ----------- {{{

function! s:setMarkdown() abort
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown onoremap <buffer>ih :<C-u>execute "normal! ?^#\\+\r:nohlsearch\rwvg_"<CR>
    autocmd FileType markdown onoremap <buffer>ah :<C-u>execute "normal! ?^#\\+\r:nohlsearch\r0vg_"<CR>
    " hyperlinking quickly
    autocmd FileType markdown vnoremap <buffer><C-l> "kc[]()<Esc>hhh"kpf(a
    autocmd FileType markdown vnoremap <buffer><C-p> "kc[]()<Esc>h"kpF[a
endfunction

" detect txt file as markdown
augroup filetype_txt
    autocmd! *
    autocmd FileType text call s:setMarkdown()
    autocmd FileType text setlocal filetype=markdown
augroup END

" vimscript
augroup filetype_vim
    autocmd! *
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" markdown
augroup filetype_markdown
    autocmd! *
    autocmd FileType text call s:setMarkdown()
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
" }}}

" ----------
" user-commands
" ----------

function s:convertToUTF8(encoding) abort
    execute 'e ++encoding=' . a:encoding
    execute 'set fileencoding=utf-8'
    execute 'write'
endfunction

command! -nargs=1 ConvertToUTF8 call s:convertToUTF8("<args>")

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
Plug 'morhetz/gruvbox'
Plug 'vim-jp/vimdoc-ja'
Plug 'tpope/vim-fugitive'
Plug 'yuugokku/yuugokku.vim'
Plug 'jamespeapen/Nvim-R'

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
    nmap <buffer>fo <Plug>(fern-action-open:vsplit)
    nmap <buffer>ft <Plug>(fern-action-open:tabedit)
    nmap <buffer>fn <Plug>(fern-action-new-file)<Plug>(fern-action-reload)
    nmap <buffer>fdir <Plug>(fern-action-new-dir)<Plug>(fern-action-reload)
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

augroup my_fern
    autocmd! *
    autocmd FileType fern call s:setFernKeys()
augroup END

let g:fern#default_hidden = 1
let g:fern#disable_drawer_smart = 1
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
let g:coc_snippet_next = "<C-l>"
let g:co_snippet_prev = "<C-h>"

if g:is_win32_unix
    let g:coc_node_path = expand('/c/nodejs/node.exe')
else
    let g:coc_node_path = 'node'
endif

" jumping
nmap <Leader>d <Plug>(coc-definition)
nmap <Leader>> <Plug>(coc-diagnostic-next)
nmap <Leader>< <Plug>(coc-diagnostic-prev)

" useful mappings
nmap crn <Plug>(coc-rename)

" text-obj
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)

xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" status line

function! StatusDiagnostic() abort
    let info = get(b:, 'coc_diagnostic_info',  {})
    if empty(info) | return '' | endif
    let msgs = ''
    if get(info, 'error', 0)
        let msgs = msgs . 'Error: ' . info['error'] . ' '
    endif
    if get(info, 'warning', 0)
        let msgs = msgs . 'Warning: ' . info['warning'] . ' '
    endif
    return msgs
endfunction
set statusline^=%{StatusDiagnostic()}

" }}}

" colorscheme: gruvbox -------------------{{{
colorscheme gruvbox
set background=dark
" }}}
