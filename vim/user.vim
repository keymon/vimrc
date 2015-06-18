" User/machine-specific settings go in here
" This file won't be included in version control and may therefore be used for
" machine-dependent settings.

" Custom key mapping as I use them with iTerm
" imap <Esc>[H;2~ <C-w>

" Load my own modules in a different location than .vim
call pathogen#infect('~/.my_vim/vim/bundle')

" Misc options and settings {{{
set swapfile                  " I want to keep the swapfiles (nvie does not)

source $VIMRUNTIME/mswin.vim  " I DO like the M$ copy&paste (via http://vim.wikia.com/wiki/Copy,_cut_and_paste)
behave mswin
set keymodel-=stopsel         " But I like arrows in visual mode too: http://vim.wikia.com/wiki/Make_arrow_keys_work_in_visual_mode_under_Windows
"}}}

" Enable colors in gnome-terminal.
" see http://askubuntu.com/questions/67/how-do-i-enable-full-color-support-in-vim
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

" Color scheme and look&feel options {{{
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
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_by_filename = 1

" NERDTtree
"let NERDTreeBookmarksFile=expand("$HOME/.vim-NERDTreeBookmarks")
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2

" Sync NerdTree to current file project directory
" From http://superuser.com/questions/195022/vim-how-to-synchronize-nerdtree-with-current-opened-tab-file-path
" returns true if is NERDTree open/active
function! rc:isNTOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" calls NERDTreeFind iff NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
function! rc:syncTree()
  if &modifiable && bufname('%') !~# 'NERD_tree_' && rc:isNTOpen() && strlen(ProjectRootGuess()) > 0 && !&diff
    ProjectRootCD
    NERDTreeCWD
    wincmd p
  endif
endfunction

" Whenever we change the buffer, sync the tree of NerdTree
autocmd BufEnter * call rc:syncTree()
" Close the editor if NerdTree is the last one
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Autoopen Nerd Tree
autocmd VimEnter * if argc() == 0 | NERDTree | endif



" }}}

" Navigation {{{
" Map Ctrl+Arrows in mac
"map! <ESC>[OA <C-Up>
"map! <ESC>[OB <C-Down>
"map! <ESC>[OD <C-Left>
"map! <ESC>[OC <C-Right>

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

" Ctrl+W close the current buffer
noremap <C-w> :bd<CR>
noremap <C-w> :bd<CR>

" " Ctrl+N create an empty buffer
noremap <C-n> :enew<CR>

" {{{
" Completion configuration
" Enter key will simply select the highlighted menu item, just as <C-Y> does
:inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" 'completeopt' option so that Vim's popup menu doesn't select the first
" completion item, but rather just inserts the longest common text of all matches
:set completeopt=longest
" }}}
