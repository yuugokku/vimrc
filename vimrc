scriptencoding utf-8
set encoding=utf-8

" ----------
" key mapping
" ----------
nnoremap <Leader>vim :vs ~/.vim/vimrc<CR>
" awesome mode changing
inoremap jk <ESC>
" surrounding
nnoremap <Leader>" viw<Esc>a"<Esc>bi"<Esc>el
nnoremap <Leader>' viw<Esc>a'<Esc>bi'<Esc>el
nnoremap <Leader>( viw<Esc>a)<Esc>bi(<Esc>el
" nervous at windowing
nnoremap -h <C-w><
nnoremap -j <C-w>+
nnoremap -k <C-w>-
nnoremap -l <C-w>>
nnoremap -H 50<C-w><
nnoremap -J 10<C-w>+
nnoremap -K 10<C-w>-
nnoremap -L 50<C-w>>

let is_win32 = has('win32unix') 

" basic settings
syntax enable
filetype plugin indent on
set nocompatible
set number
set incsearch
set hlsearch
set cursorline
set laststatus=2
set hidden
set updatetime=400
set nobackup
set nowritebackup
set shiftwidth=4 tabstop=4 expandtab autoindent smartindent
set nowrap
set history=2000
set noswapfile nobackup

augroup filetype_markdown
    autocmd BufReadPre *.md setlocal wrap
augroup END

" ----------
" vim-plug settings
" ----------
call plug#begin('~/.vim/plugins')

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
" Make sure some common comands about twitvim starts with <C-t>
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
if is_win32
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

nmap <Leader>fern :Fern -drawer .<CR>

function! s:set_fernkeys()
    nmap <buffer>fo <Plug>(fern-action-open:vsplit)
    nmap <buffer>fn <Plug>(fern-action-new-file)<Plug>(fern-action-reload)
    nmap <buffer>fd <Plug>(fern-action-new-dir)<Plug>(fern-action-reload)
    nmap <buffer>fc <Plug>(fern-action-copy)<Plug>(fern-action-reload)
    nmap <buffer>fm <Plug>(fern-action-move)<Plug>(fern-action-reload)
    nmap <buffer>fdel <Plug>(fern-action-trash)<Plug>(fern-action-reload)
    nmap <buffer>frn <Plug>(fern-action-rename)<Plug>(fern-action-reload)
    nmap <buffer>frl <Plug>(fern-action-reload)
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

if is_win32
    let g:coc_node_path = expand('/c/nodejs/node.exe')
else
    let g:coc_node_path = 'node'
endif

