map <ESC>[5D <C-Left>
map <ESC>[5C <C-Right>
map! <ESC>[5D <C-Left>
map! <ESC>[5C <C-Right>

" User/machine-specific settings go in here
" This file won't be included in version control and may therefore be used for
" machine-dependent settings.

" Custom key mapping as I use them with iTerm
" imap <Esc>[H;2~ <C-w>

" Load my own modules in a different location than .vim
call pathogen#infect('~/.my_vim/vim/bundle')

" Enable colors in gnome-terminal.
" see http://askubuntu.com/questions/67/how-do-i-enable-full-color-support-in-vim
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

" Color scheme and look&feel options {{{

" Low highlight for the list chars
let g:solarized_visibility='low'

set background=dark

let g:solarized_termcolors=256
colorscheme solarized

" Add the column marc for 80 chars
set colorcolumn=+1
set colorcolumn=80

" set macvim specific stuff
if has("gui_running")
  set lines=50 columns=140 " Initial size

  if has("gui_gtk2")
    set guifont=Monospace\ 10
  elseif has("gui_macvim")
    set guifont=Monaco:h14
    "macmenu &Edit.Find.Find\.\.\. key=<nop> " free up Command-F
    "macmenu &File.Open\ Tab\.\.\. key=<nop> " free up Command-T
    "macmenu &File.New\ Tab key=<D-T>        " 'New Tab' is now Shift-Command-T
    map <D-t> :FuzzyFinderFile<CR>
    map <D-f> :set invfu<CR>                " toggle fullscreen mode
    map <D-Enter> :set invfu<CR>            " toggle fullscreen mode

    " Command-W closes current buffer
    map <D-w> :bd<CR>                " Command-W closes current buffer

    set fuopt+=maxhorz                      " grow to maximum horizontal width on entering fullscreen mode
    "macmenu &File.Open\.\.\. key=<nop>      " free up Command-O
    "imap <D-o> <C-o>o
    "imap <D-O> <C-o>O

    "macmenu &Edit.Select\ All key=<nop>     " free up Command-A
    "imap <D-a> <C-o>A
    "imap <D-i> <C-o>I
    "imap <D-0> <C-o>gI

  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif


" }}}


" CtrlP and NerdTree setup {{{

" Shortcuts
nnoremap \\ :ProjectRootExe :NERDTreeToggle<CR> " Open Nerdtree
nnoremap \|\| :ProjectRootExe :CtrlP<CR> " Open Ctrl-P
nnoremap <F11> :ProjectRootExe :NERDTreeToggle<CR> " Open NerdTree with Ctrl+n

" for CtrlP
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.class,*.jar
let g:ctrlp_root_markers = ['.git', '.acignore', '.gitignore']
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_by_filename = 1

" NERDTtree
"let NERDTreeBookmarksFile=expand("$HOME/.vim-NERDTreeBookmarks")
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2

" Sync NerdTree to current file project directory
" From http://superuser.com/questions/195022/vim-how-to-synchronize-nerdtree-with-current-opened-tab-file-path
" returns true if is NERDTree open/active
function! NERDTreeIsOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" calls NERDTreeFind iff NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
function! NERDTreeSyncTree()
  if &modifiable && bufname('%') !~# 'NERD_tree_' && NERDTreeIsOpen() && strlen(ProjectRootGuess()) > 0 && !&diff
    ProjectRootCD
    NERDTreeCWD
    wincmd p
  endif
endfunction

" Whenever we change the buffer, sync the tree of NerdTree
autocmd BufEnter * call NERDTreeSyncTree()
" Close the editor if NerdTree is the last one
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Autoopen Nerd Tree
autocmd VimEnter * if argc() == 0 | NERDTree | wincmd p | endif



" }}}

" Navigation {{{
" Map Ctrl+Arrows in mac
"imap <Esc>[OA <Esc>ki
"imap <Esc>[OB <Esc>ji
"imap <Esc>[OC <Esc>li
"imap <Esc>[OD <Esc>hi

" User Ctrl+Arrows to switch buffers... In NerdTree that exits nerdtree
map <expr> <C-Right> bufname('%') !~# 'NERD_tree_' ? ":bn<CR>" : ":wincmd p<CR>"
"map <C-Right> :bn<CR>
map <expr> <C-Left> bufname('%') !~# 'NERD_tree_' ? ":bp<CR>" : ":wincmd p<CR>"
"map <C-Left> :bp<CR>

" Sorry, I DO like the arrows :P
nnoremap k gk
nnoremap j gj
nnoremap <down> gj
nnoremap <up> gk
nnoremap <left> h
nnoremap <right> l
" Arrow keys move naturally in wrapped lines
vnoremap <down> gj
vnoremap <up> gk
inoremap <down> <C-o>gj
inoremap <up> <C-o>gk

" Load Control-P with ,p
nnoremap <leader>p :CtrlP<cr>
" }}}

" Some useful functions
" {{{
" Change to xml edition with folding based on tabs. Ideal for the TW Go CI xml
function! XMLTime()
  set filetype=xml
  set foldmethod=indent
  set foldlevelstart=2
endfunction
command! XMLTime call XMLTime()

" }}}

" Leader+w remove the trailing whitespaces:
" http://stackoverflow.com/questions/3474709/delete-all-spaces-and-tabs-at-the-end-of-my-lines
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
noremap <leader>w :call DeleteTrailingWS()<CR>

" {{{
" Add the auto remove trailing spaces before save
autocmd BufWritePre * :%s/\s\+$//e
" }}}

" " Ctrl+N create an empty buffer
noremap <C-n> :enew<CR>

" {{{
" Completion configuration
" Enter key will simply select the highlighted menu item, just as <C-Y> does
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" 'completeopt' option so that Vim's popup menu doesn't select the first
" completion item, but rather just inserts the longest common text of all matches
set completeopt=longest

" Some handy aliases for the ctags
noremap <C-}> <C-t>
" }}}

nnoremap <F8> :TagbarToggle<CR> " Open TagBar

" Misc options and settings {{{
set swapfile                  " I want to keep the swapfiles (nvie does not)

source $VIMRUNTIME/mswin.vim  " I DO like the M$ copy&paste (via http://vim.wikia.com/wiki/Copy,_cut_and_paste)
behave mswin
set keymodel-=stopsel         " But I like arrows in visual mode too: http://vim.wikia.com/wiki/Make_arrow_keys_work_in_visual_mode_under_Windows

" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y

" CTRL-V and SHIFT-Insert are Paste
map <C-V>       "+gP
map <S-Insert>  "+gP

cmap <C-V>      <C-R>+
cmap <S-Insert> <C-R>+

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.

exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

imap <S-Insert> <C-V>
vmap <S-Insert> <C-V>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q>   <C-V>

" From http://vim.wikia.com/wiki/Shifting_blocks_visually
" tabbing changes does not remove selection
vnoremap > >gv
vnoremap < <gv

nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
snoremap <Tab> >gv
snoremap <S-Tab> <gv


"}}}

imap <C-kPlus>  <ESC>:call LargerFont()<CR>i
nmap <C-kPlus>  :call LargerFont()<CR>

imap <C-kMinus> <ESC>:call SmallerFont()<CR>i
nmap <C-kMinus> :call SmallerFont()<CR>

" {{{
" CTRL+I increments
noremap <C-I> <C-A>

" CTRL-A is Select all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG
" }}}



" Fix issue with cursors in vim with fast repeat keys and slow bufferline
au FileType gitcommit au! bufferline InsertLeave
au FileType gitcommit au! InsertLeave
au FileType gitcommit au! supertab_retain  InsertLeave
"au FileType gitcommit au! unimpaired_paste  InsertLeave
au FileType gitcommit au! YankRing InsertLeave

" Close current buffer (Upper case to force close)
noremap <leader>q :bd<CR>
noremap <leader>Q :bd!<CR>

" Go code with 2 tab width, but no expand tabs
au BufNewFile,BufRead *.go setlocal noet ts=2 sw=2 sts=2

au BufNewFile,BufRead *.go let g:go_fmt_command = "goimports"

" Try to make vim syntax highlight faster
" See: https://github.com/fatih/vim-go/issues/145
set nocursorcolumn
syntax sync minlines=256
set re=1
