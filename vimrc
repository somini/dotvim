" somini.vimrc

" Pathogen {{{
runtime 3rd_party/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect('1st_party/{}','3rd_party/{}')
"}}}

" Legacy Stuff {{{
set nocompatible "Vim, not vi
set backspace=indent,eol,start "Deletes work as intended
set showcmd "Show the command line as you type
set modeline "Enable modeline
if has('autocmd')
	filetype plugin indent on "Enable filetype detection
endif
" GUI Options {{{
" Needs to be set here, to influence GUI loading
" set guioptions-=M "Don't load $VIMRUNTIME/menu.vim
" set guioptions-=f "Don't fork from the shell
" }}}
" }}}

" Utilities {{{
let g:user_dir=expand("<sfile>:p:h")
"SetToggle: Toggle complex options {{{
function SetToggle(option, value)
	" Check if the option contains value
	if stridx(getwinvar(winnr(), '&'.a:option), a:value) == -1
		let l:operator='+='
	else "Exists, remove it
		let l:operator='-='
	endif
	execute 'set '.a:option.l:operator.a:value
endfunction
" }}}
" }}}

" Clipboard {{{
set clipboard=unnamedplus " Sync the unnamed register with the system clipboard
" Insert mode {{{
	" C-q does what C-v did, insert raw characters
	inoremap <C-q> <C-v>
	" C-v pastes
	execute 'imap <script> <C-V> <C-G>u' . paste#paste_cmd['i']
"}}}
" Command mode {{{
	" C-y pastes
	cnoremap <C-y> <C-r>+
"}}}
"}}}

" Data Safety and Managing {{{
function CheckDir(dir) "{{{
  if !isdirectory(a:dir)
    call mkdir(a:dir,"p")
  endif
endfunction "}}}

" Vim Info {{{
set viminfo='150 "Save the marks for this much files !must exist!
set viminfo+=f0 "Don't save '0 to '9
set viminfo+=! "Save upper-case variables
set viminfo+=% "Save the bufferlist when started with no file
set viminfo+=h  "Don't activate search highlight on start
set viminfo+=s50 "Don't save registers larger than this Kb
set viminfo+=<100 "nor larger than these lines
" set viminfo+=r$SKIP_PATH_PREFIX
" set viminfo+=n$VIMINFO_FILENAME !must be the last one!
" }}}
" Undo {{{
set undofile
" set undodir=OS_specific
set undolevels=1500 " Undo forever
" }}}
" Views {{{
" set viewdir=OS_specific
set viewoptions+=slash " The One True Path Separator
set viewoptions+=unix  " The One True Format
"}}}
" Swap Files {{{
" set directory=OS_specific
" }}}
" Backup Files {{{
set backup writebackup "Backup and delete old file
set backupcopy=yes
" set backupdir=OS_specific
" Don't backup this file patterns
let &backupskip=expand($VIMRUNTIME).'/*'
set backupext=.vim.bak
" }}}
" Sessions {{{
set sessionoptions-=help    "Don't store the help windows
set sessionoptions-=options "Don't store options in sessions
set sessionoptions+=slash   "The One True Path Separator
set sessionoptions+=unix    "The One True Format
" }}}
" }}}

" Appearance {{{
set background=dark
if &t_Co >= 256 || has('gui_running') " Something nice
	colorscheme harlequin
else "Sensible fallback
	colorscheme evening
endif
syntax enable
set hlsearch "Highlight searches ...
set laststatus=2 "Always show the statusline
nohlsearch "but not when starting up
"{{{ Non-Printable Characters
set list "Show non-printable characters
let &listchars = 'tab:  '
"Alternate tab: ≈~
set listchars+=trail:•
set listchars+=precedes:⇇,extends:⇉
set listchars+=nbsp:·
" set listchars+=eol:¶
"}}}
"}}}

" Navigation {{{
nnoremap          <Space>    <C-d>
nnoremap          <S-Space>  <C-u>
nmap              g<Space>   <S-Space>
nnoremap <silent> <C-Left>   :bprevious<CR>
nnoremap <silent> <C-Right>  :bnext<CR>
nnoremap <silent> <S-Left>   :tabprevious<CR>
nnoremap <silent> <S-Right>  :tabnext<CR>
set hidden "Don't prompt when changing buffers
"}}}

" Diff & Splits {{{
" Diffs {{{
set diffopt+=iwhite "Ignore whitespace on diffs
"}}}
" Splits {{{
set splitright " New splits to the right
"}}}
"}}}

" Search {{{
set ignorecase smartcase "Sane defaults
set incsearch "Start searching right away
"}}}

" Mouse {{{
set mouse=a "Enable the mouse in all modes
set selectmode= "But no select mode, ever
"}}}

" Help {{{
"TODO: :Help to put the help in the ":vertical topleft"
" <F1> for choosing help
nnoremap <F1>      :vertical topleft help<Space>
" Double <F1> for "Just show me the help!"
" nnoremap <F1><F1>  :vertical topleft help<CR>
" <F1> on Insert mode does the same
imap <F1> <C-o><F1>
"}}}

" Whitespace Management {{{
set autoindent smartindent "Indent in smart, language-specific ways
" Enter {{{
" On normal mode, Enter put a new line after the current one
nnoremap <CR>   :put =''<CR>
" And S-Enter puts it before
nnoremap <S-CR> :put! =''<CR>
" Synonym for terminals
nmap     g<CR>  <S-CR>
"}}}
" Tab {{{
" Tab to indent text
nnoremap <Tab> >>
nnoremap <S-Tab> <<
nnoremap g<Tab> <S-Tab>
" On visual mode, keep the indented text select
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
vnoremap g<Tab> <S-Tab>
"
"}}}
"}}}

" 2Leader Commands{{{
" cd: Change dir to the current file
nnoremap <LocalLeader><LocalLeader>cd        :lcd %:h<CR>:pwd<CR>
" b : Show a list of buffers and prompt for a number
nnoremap <LocalLeader><LocalLeader>b         :buffers<CR>:buffer<Space>
"}}}

" Plugin Configuration {{{
" CtrlP {{{
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20'
let g:ctrlp_clear_cache_on_exit = 1 "Cache the results, F5 to purge
let g:ctrlp_open_new_file = 'r' "Create new files in the current window
let g:ctrlp_open_multiple_files = '1i' "Open multi files in hidden buffers
let g:ctrlp_key_loop = 0 "Multi-byte keys (eg. tilde in PT keyboard)
" Abbreviations {{{
let g:ctrlp_abbrev = {
\ 'gmode': 'i',
\ 'abbrevs': [
	\ {
	\ 'pattern': '^@v',
	\ 'expanded': '@cd '.g:user_dir,
	\ 'mode': 'pfrz',
	\ },
\ ],
\ }
"}}}
"}}}
" NERDTree {{{
let g:NERDTreeShowBookmarks = 1
"}}}
" Airline {{{
" let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#tabline#enabled = 1 "Show a tabline
let g:airline#extensions#tabline#show_buffers = 1 "If there's only one tab, show the buffers
let g:airline#extensions#tabline#buffer_min_count = 2 "But only if there's more than 1
let g:airline#extensions#tabline#tab_nr_type = 1 "Show tabnumbers
let g:airline#extensions#tabline#formatter = 'unique_tail_improved' "Uniquify filenames
let g:airline#extensions#tabline#show_close_button = 0
"}}}
"{{{ Bufferline
let g:bufferline_echo = 0 "No echo on command line
let g:bufferline_rotate = 1 "Keep the current buffer name visible
"}}}
"}}}

" Modeline {{{
" vim:ft=vim:ts=2:sw=2:fdm=marker
"}}}
