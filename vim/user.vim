" User/machine-specific settings go in here
" This file won't be included in version control and may therefore be used for
" machine-dependent settings.

" Custom key mapping as I use them with iTerm
" imap <Esc>[H;2~ <C-w>

" Load my own modules in a different location than .vim
call pathogen#infect('~/.my_vim/vim/bundle')

" Misc options and settings {{{
set swapfile                  " I want to keep the swapfiles (nvie does not)
"}}}

" Color scheme and look&feel options {{{
set background=dark

let g:solarized_termcolors=256
colorscheme solarized

" set macvim specific stuff
if has("gui_macvim")
  set guifont=Monaco:h14
  set lines=50 columns=140 " Initial size

  set fuopt+=maxhorz                      " grow to maximum horizontal width on entering fullscreen mode
  macmenu &amp;Edit.Find.Find\.\.\. key=<nop> " free up Command-F
  map <D-f> :set invfu<CR>                " toggle fullscreen mode

  macmenu &File.Open\ Tab\.\.\. key=<nop> " free up Command-T
  macmenu &File.New\ Tab key=<D-T>        " 'New Tab' is now Shift-Command-T
  map <D-t> :FuzzyFinderFile<CR>

  "macmenu &File.Open\.\.\. key=<nop>      " free up Command-O
  "imap <D-o> <C-o>o
  "imap <D-O> <C-o>O

  "macmenu &Edit.Select\ All key=<nop>     " free up Command-A
  "imap <D-a> <C-o>A
  "imap <D-i> <C-o>I
  "imap <D-0> <C-o>gI
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
