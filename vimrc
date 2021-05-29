set nocompatible
scriptencoding utf-8
set encoding=utf-8

" ----------
" key mapping
" ----------
nnoremap <Leader>v :vs $MYVIMRC<CR>
" awesome mode changing
inoremap jk <ESC>
" surrounding
nnoremap <Leader>" viw<Esc>a"<Esc>bi"<Esc>el
nnoremap <Leader>' viw<Esc>a'<Esc>bi'<Esc>el
nnoremap <Leader>( viw<Esc>a)<Esc>bi(<Esc>el
inoremap {<Tab> {<CR>}<Esc>ko
" nervous at windowing
nnoremap -h <C-w><
nnoremap -j <C-w>+
nnoremap -k <C-w>-
nnoremap -l <C-w>>
nnoremap -H 50<C-w><
nnoremap -J 10<C-w>+
nnoremap -K 10<C-w>-
nnoremap -L 50<C-w>>

let g:is_win32_unix = has('win32unix')
let g:is_win32 = has('win32')

" basic settings
syntax enable
filetype plugin indent on
set number
set incsearch
set hlsearch
set cursorline
set laststatus=2
set hidden
set updatetime=400
set nobackup
set nowritebackup
set shiftwidth=4 tabstop=4 expandtab autoindent
set nowrap
set history=2000
set noswapfile nobackup noundofile
set ambiwidth=double
set termguicolors

augroup filetype_markdown
    autocmd BufReadPre *.md setlocal wrap
augroup END

function! s:get_vimdir() abort
    if g:is_win32
        return '~/vimfiles'
    else
        return '~/.vim'
    endif
endfunction

" ----------
" vim-plug settings
" ----------

" vim-plug automatic installation
let s:vimplug_dir = expand(s:get_vimdir() . '/autoload')
let s:vimplug_target = expand(s:vimplug_dir . '/plug.vim')

if empty(glob(s:vimplug_target))
    silent execute '!curl -fLo ' . s:vimplug_target . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" I understand what these lines below will do.
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
            \| PlugInstall --sync | source $MYVIMRC
            \| endif

let s:vimplug_repo = expand(s:get_vimdir() . '/plugins')

call plug#begin(s:vimplug_repo)

Plug 'junegunn/vim-plug'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rust-lang/rust.vim'
Plug 'lambdalisue/fern.vim'
Plug 'twitvim/twitvim'
Plug 'vim-jp/vimdoc-ja'

call plug#end()

" ----------
" plugin-related key mappings
" ----------
" twitvim
" Make sure some common commands about twitvim starts with <C-t>
nnoremap <C-t>tl :FriendsTwitter<CR>
nnoremap <C-t>p :ProfileTwitter<CR>
nnoremap <C-t>n :MentionsTwitter<CR>
nnoremap <C-t>sw :SwitchLoginTwitter<CR>
nnoremap <C-t>j :PosttoTwitter<CR>
nnoremap <C-t>h :PreviousTwitter<CR>
nnoremap <C-t>l :NextTwitter<CR>
" configure the number of tweets returned by :FriendsTwitter
let twitvim_count = 100
" default browser
if g:is_win32
    let g:twitvim_browser_cmd = ''
else 
    let g:twitvim_browser_cmd = 'firefox'
endif

" rust.vim
let g:rustfmt_autosave = 1

" japanese document
set helplang=ja,en

" Fern.vim
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


" Coc.nvim installation and settings
let g:coc_global_extensions = [
            \'coc-rust-analyzer',
            \'coc-pyright',
            \'coc-html',
            \'coc-css',
            \'coc-json'
            \]

if g:is_win32_unix
    let g:coc_node_path = expand('/c/nodejs/node.exe')
else
    let g:coc_node_path = 'node'
endif

