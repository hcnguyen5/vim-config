source ~/.vim/vimrc

set guifont=Monaco:h10

filetype plugin indent on

syntax enable

au BufNewFile,BufRead *.handlebars setlocal ft=html

set background=dark
colorscheme xoria256

tab all
set nocompatible

set ruler

set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent

set iskeyword=@,48-57,192-255

let mapleader=','

" Escape/unescape & < > HTML entities in range (default current line).
function! HtmlEntities(line1, line2, action)
  let search = @/
  let range = 'silent ' . a:line1 . ',' . a:line2
  if a:action == 0  " must convert &amp; last
    execute range . 'sno/&lt;/</eg'
    execute range . 'sno/&gt;/>/eg'
    execute range . 'sno/&amp;/&/eg'
  else              " must convert & first
    execute range . 'sno/&/&amp;/eg'
    execute range . 'sno/</&lt;/eg'
    execute range . 'sno/>/&gt;/eg'
    execute range . 'sno/"/&quot;/eg'
    execute range . "sno/'/&apos;/eg"
    execute range . "sno/{{/&#123;{/eg"
  endif
  nohl
  let @/ = search
endfunction
command! -range -nargs=1 Entities call HtmlEntities(<line1>, <line2>, <args>)
vnoremap <silent> h :Entities 1<CR>
vnoremap <silent> H :Entities 0<CR>

"====[ Set up smarter search behaviour ]=======================

set incsearch       "Lookahead as search pattern is specified
set ignorecase      "Ignore case in all searches...
set smartcase       "...unless uppercase letters used

set hlsearch        "Highlight all matches
highlight clear Search
highlight       Search    ctermfg=White

"Delete in normal mode switches off highlighting till next search...
nmap <silent> <BS> :nohlsearch
set nohlsearch

set timeoutlen=100

"====[ Edit and auto-update this config file and plugins ]==========

augroup VimReload
autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

nmap <silent>  ;v   [Edit .vimrc]          :next $MYVIMRC<CR>
nmap           ;vv  [Edit .vim/plugin/...] :next $HOME/.vim/plugin/

"====[ Goto last location in non-empty files ]=======

autocmd BufReadPost *  if line("'\"") > 1 && line("'\"") <= line("$")
                   \|     exe "normal! g`\""
                   \|  endif


"====[ I'm sick of typing :%s/.../.../g ]=======

nmap S  [Shortcut for :s///g]  :%s//g<LEFT><LEFT>
vmap S                         :s//g<LEFT><LEFT>

"=======[ Fix smartindent stupidities ]============

set autoindent                              "Retain indentation on next line
set smartindent                             "Turn on autoindenting of blocks

inoremap # X<C-H>#|                         "And no magic outdent for comments
nnoremap <silent> >> :call ShiftLine()<CR>| "And no shift magic on comments

function! ShiftLine()
  set nosmartindent
  normal! >>
  set smartindent
endfunction

"=====[ Make Visual modes work better ]==================

"Square up visual selections...
set virtualedit=block

" Make BS/DEL work as expected in visual modes (i.e. delete the selected text)...
vmap <BS> x


"=====[ Remap space key to something more useful ]========================

" Use space to jump down a page (like browsers do)...
" nnoremap <Space> <PageDown>

"=====[ Show the column marker in visual insert mode ]====================

vnoremap <silent>  I  I<C-R>=TemporaryColumnMarkerOn()<CR>
vnoremap <silent>  A  A<C-R>=TemporaryColumnMarkerOn()<CR>

function! TemporaryColumnMarkerOn ()
    set cursorcolumn
    inoremap <silent>  <ESC>  <ESC>:call TemporaryColumnMarkerOff()<CR>
    return ""
endfunction

function! TemporaryColumnMarkerOff ()
    set nocursorcolumn
    iunmap <ESC>
endfunction

