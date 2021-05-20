scriptencoding utf-8
" key mapping
nnoremap <Leader>vim :vs ~/.vim/vimrc<CR>
inoremap jk <ESC>

let is_win32 = has('win32unix') 

" basic settings
" UTF-8
set encoding=utf-8
set nocompatible
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
set shiftwidth=4 tabstop=4 expandtab autoindent smartindent
set nowrap
set history=2000

" vim-plug settings
call plug#begin('~/.vim/plugins')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rust-lang/rust.vim'

Plug 'lambdalisue/fern.vim'
Plug 'twitvim/twitvim'
Plug 'vim-jp/vimdoc-ja'

call plug#end()

" twitvim
" plugin-related key mappings
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
nnoremap <Leader>fern :Fern -drawer .<CR>

let g:fern#default_hidden=1

" -----settings for plugins-----
let setting_filepath = expand('~/.vimsetting')
let chk = getftype(setting_filepath)

" Coc.nvim installation
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


if chk == 'file'
    finish
endif

" vim-plug installation
PlugInstall


let lines = ["everything set!"]
call writefile(lines, setting_filepath)

