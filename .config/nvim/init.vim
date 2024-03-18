" Ranger ----
let g:ranger_replace_netrw = 1
let g:ranger_map_keys = 0
map <leader>r :Ranger<CR>
set shell=bash
" -----------

" Fzf ----------
set ttimeout
set timeoutlen=1000 ttimeoutlen=0
let $FZF_DEFAULT_COMMAND = "find -L -type f"
nnoremap <silent> <leader>f <CMD>Files<CR>
nnoremap <silent> <leader>g :Ag<CR>
nnoremap <silent> <leader>bb :Buffers<CR>
let g:fzf_preview_window = ['up,80%', 'ctrl-/']
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
" --------------

" Fern ---------
nnoremap <leader>e :Fern -drawer . -toggle -reveal=%<CR>
let g:fern#renderer = "nerdfont"
" --------------

" Prettier -----
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
" --------------

" COC Related --
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

set updatetime=100

:highlight SignColumn ctermbg=NONE ctermfg=yellow
set signcolumn=number
:hi CocWarningSign ctermbg=172 ctermfg=226
:hi CocErrorSign ctermbg=88 ctermfg=196
" --------------

:lua require('plugins')

" Buffer/Tab Configs --------------
function! CloseOnLast()
  let cnt = 0

  for i in range(0, bufnr("$"))
    if buflisted(i)
      let cnt += 1
    endif
  endfor

  if cnt <= 1
    exec 'Dashboard'
  else
    :bw 
  endif
endfunction

function! NewTabFzf()
  :tabnew
  redraw
  :Files
endfunction

map <C-H> gT
map <C-L> gt
nnoremap <C-t> :call NewTabFzf()<CR>
map - :call CloseOnLast()<CR>
" ---------------------------------

" Emmet -------
imap ,, <C-y>,
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'jsx',
    \  },
  \}
" -------------

" Strikethrough Formatting -----
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_auto_extension_ext = 'txt'
nnoremap <leader>st I~~ <ESC>A ~~<ESC>:noh<CR>
nnoremap <leader>ust :s/^\~\~ //<CR>:s/ \~\~$//<CR>:noh<CR>
" -----------------------------------

" WSL yank support ------------------
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif
"------------------------------------

" General Settings ------------------
set expandtab
set tabstop=2
set shiftwidth=2
set nowrap
set number relativenumber
set nocompatible
set noswapfile
"-----------------------------------

" Shortcut Re-Maps ------
nnoremap <Leader>s Vip:sort<CR>
nnoremap <Leader>q ciw""<Esc>P
nnoremap <silent> <CR> :nohlsearch<CR>
nnoremap <silent><Leader>n :edit ~/notes<CR>
nnoremap <silent><Leader>j :W<CR>
"nnoremap <silent><Leader>v :tabnew<CR>:e $MYVIMRC<CR>

" Toggle vertical split tab for vimrc
function! ToggleVimrc()
  let vimrc_tabnr = bufwinnr($MYVIMRC)

  if vimrc_tabnr != -1
    " Close the vertical split tab
    exe vimrc_tabnr . 'wincmd c'
  else
    " Open vimrc in a vertical split tab on the right with a width of 30 columns
    vsplit $MYVIMRC | wincmd L | vertical resize 80
  endif
endfunction

" Define a shortcut to toggle vimrc tab
nnoremap <leader>v :call ToggleVimrc()<CR>

" Python comment selection 
vnoremap <silent><Leader>c I#<Esc>

" Javascript comment selection - if js, change comment to js comment instead
" of react
if &filetype == 'javascript' || &filetype == 'typescriptreact'
  vnoremap <silent><Leader>c I//<Esc>
endif

" Remap increment and decrement since tmux using Ctrl-a as leader 
nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>

"nnoremap <A-j> :m +1<CR>
"nnoremap <A-k> :m -2<CR>
"vnoremap <A-j> :m '>+1<CR>gv=gv
"vnoremap <A-k> :m '<-2<CR>gv=gv

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Status bar stuff ------
set laststatus=2
set statusline=2
set statusline =%7*%=%0*\ 
set statusline +=%f\ %m%r%*%0*%h%w%*\ 
set statusline +=\-\ 
set statusline +=%l\:%v\ \ 

set cmdheight=0

set winbar=\ 

highlight StatusLine cterm=none ctermbg=none ctermfg=DarkCyan

highlight CustomColor1 ctermfg=DarkCyan ctermbg=none
highlight CustomColor2 ctermfg=DarkMagenta ctermbg=none
highlight CustomColor3 ctermfg=179 ctermbg=38
highlight CustomColor4 ctermfg=179 ctermbg=DarkMagenta

set showtabline=1
set tabline=%!MyTabLine()

function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i == 0
      let s ..= '%#CustomColor1#%#TabLine# %#CustomColor1# '
    endif

    if i + 1 == tabpagenr()
      let s ..= '%#CustomColor2#%#TabLineSel#'
    else
      let s ..= '%#CustomColor1#%#TabLine#'
    endif
    " set the tab page number (for mouse clicks)
    let s ..= '%' .. (i + 1) .. 'T'
    " the label is made by MyTabLabel()
    if i + 1 == tabpagenr()
      let s ..= '%{BufferModified(' .. (i + 1) .. ')}%#TabLineSel#%t   %999X%#CustomColor2# %#TabLineSel#'
    else
      let s ..= '%{BufferModified(' .. (i + 1) .. ')}%#TabLine#%{MyTabLabel(' .. (i + 1) .. ')}   %' .. (i + 1) .. 'X%#CustomColor1# %#TabLine#'
    endif
  endfor
  " after the last tab fill with TabLineFill and reset tab page nr
  let s ..= '%#TabLineFill#%T'
  return s
endfunction

function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return fnamemodify(bufname(buflist[winnr - 1]), ':t')
endfunction

function! BufferModified(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bname = bufname(buflist[winnr - 1])
  if getbufvar(bname, '&mod')
    return " "
  else 
    return ""
  endif
endfunction

set title

" Show top tab bar always - That way we can see filename at top
set showtabline=2

syntax on
set cursorline
highlight Comment ctermfg=blue
highlight Cursor cterm=none ctermfg=Yellow ctermbg=Green
highlight CursorLine cterm=none ctermbg=237 ctermfg=none
highlight LineNr cterm=none ctermbg=none ctermfg=DarkCyan
highlight CursorLineNr cterm=none ctermbg=DarkCyan ctermfg=DarkYellow
highlight TabLineSel cterm=none ctermfg=DarkBlue ctermbg=DarkMagenta
highlight TabLine cterm=none ctermfg=DarkMagenta ctermbg=DarkCyan
highlight TabLineFill cterm=none ctermfg=DarkCyan ctermbg=none

call plug#begin('~/.local/share/nvim/plugged')

Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'mattn/emmet-vim'
Plug 'vimwiki/vimwiki'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', {'branch': '0.1.x'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-tree/nvim-web-devicons' " optional
Plug 'nvim-tree/nvim-tree.lua'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'

call plug#end()
