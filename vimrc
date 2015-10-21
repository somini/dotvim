" somini.vimrc

" Legacy Stuff {{{
set nocompatible "Vim, not vi
" Force UTF-8 for insane systems
set encoding=utf-8
scriptencoding utf-8
set fileencodings=ucs-bom,utf-8,default,latin1

set backspace=indent,eol,start "Backspace works as intended
set showcmd "Show the command line as you type
set modeline "Enable modeline
if has('autocmd')
	filetype plugin indent on "Enable filetype detection
endif
set updatetime=500 "ms
" Timeouts and stuff, Esc is instantaneous but can also be used in mappings
set notimeout
set ttimeout
set ttimeoutlen=100 "ms
if v:version > 703 || v:version == 703 && has("patch541")
	set formatoptions+=j " Delete comment character when joining commented lines
endif
" i_C-u shouldn't delete so much
inoremap <C-u> <C-g>u<C-u>
" Baffling default
nnoremap Y y$
" GUI Options {{{
" Needs to be set here, to influence GUI loading
" set guioptions-=M "Don't load $VIMRUNTIME/menu.vim
" set guioptions-=f "Don't fork from the shell
" }}}
" }}}

" Pathogen {{{
runtime 3rd_party/vim-pathogen/autoload/pathogen.vim
if !exists('*pathogen#infect')
	let s:error_marker = expand('<sfile>:p:h').'/.novimrc'
	if !filereadable(s:error_marker) " Warn only the first time
		echohl WarningMsg
			echo "Can't load pathogen, won't change any options!"
			echo "Try running `git submodule update` or clone the repo recursively"
		echohl None
		" Create the marker file
		silent execute 'tabnew '.s:error_marker
		silent write!
		silent tabclose
	endif
	augroup vimrc_pathogen | autocmd!
		autocmd VimEnter * echohl ErrorMsg | exec 'echo "'.'Fix the vim folder and `rm '.s:error_marker.'`"' | echohl None
	augroup END
	colorscheme blue "Ugly-ass colors to hammer the point home
	finish
endif
execute pathogen#infect('1st_party/{}','3rd_party/{}')
"}}}

" Utilities {{{
let g:user_dir=expand("<sfile>:p:h")
"SetToggle: Toggle complex options {{{
function! SetToggle(option, value)
	" Check if the option contains value
	if stridx(getwinvar(winnr(), '&'.a:option), a:value) == -1
		let l:operator='+='
	else "Exists, remove it
		let l:operator='-='
	endif
	execute 'set '.a:option.l:operator.a:value
endfunction
" }}}
"IsEmptyBuffer: Check if the current buffer is empty {{{
function! IsEmptyBuffer()
	if line('$') == 1 && getline(1) ==# '' && !&modified
		return 1
	else
		return 0
	endif
endfunction
"}}}
" Command line configuration
" Complete the longest common prefix, then use <Tab> to cycle
" through the various matches.
set wildmenu
set wildmode=longest:full,list:full
set wildignorecase "Ignore case

" Insert completion configuration
" Keep the same-ish configuration from the command line
" The SuperTab plugin helps with the rest
set complete=.,w,b,u,t,i
set completeopt=menu,preview,longest

set lazyredraw "Don't update the screen in the middle of macros, etc
set autoread "Re-read files if they haven't been changed in vim
" More information with less clicks
nnoremap <C-g> 2<C-g>
" Keep the cursor still when joining lines
nnoremap J m`J``

" Move lines {{{
nnoremap <silent> + :move +1<CR>
nnoremap <silent> - :move -2<CR>
vnoremap <silent> + :call <SID>MoveCurrentBlock(1)<CR>gv
vnoremap <silent> - :call <SID>MoveCurrentBlock(-1)<CR>gv
function! s:MoveCurrentBlock(offset) range
	" Only on V-Line visual mode
	if !a:offset || a:offset == 0 || visualmode() !=# 'V'
		return
	endif
	let l:range = a:lastline - a:firstline + 1
	if a:offset > 0
		let l:move = a:lastline + a:offset
	else
		let l:move = a:firstline + a:offset - 1
	endif
	if l:move > line('$')
		return
	endif
	execute a:firstline.','.a:lastline.'move '.l:move
endfunction
"}}}
" Keep buffer locations "{{{
if v:version >= 700
" Save current view settings on a per-window, per-buffer basis. "{{{
function! s:AutoSaveWinView()
	if !exists("w:vimrc_bufview")
		let w:vimrc_bufview = {}
	endif
	let w:vimrc_bufview[bufnr("%")] = winsaveview()
endfunction "}}}
" Restore current view settings. "{{{
function! s:AutoRestoreWinView()
	let l:buf = bufnr("%")
	if exists("w:vimrc_bufview") && has_key(w:vimrc_bufview, l:buf)
		let l:v = winsaveview()
		let atStartOfFile = l:v.lnum == 1 && l:v.col == 0
		if atStartOfFile && !&diff
			call winrestview(w:vimrc_bufview[l:buf])
		endif
		unlet w:vimrc_bufview[l:buf]
	endif
endfunction "}}}
	augroup vimrc_winview | autocmd!
		" When switching buffers, preserve window view.
		autocmd BufLeave * call <SID>AutoSaveWinView()
		autocmd BufEnter * call <SID>AutoRestoreWinView()
	augroup END
endif
"}}}
" }}}

" Clipboard {{{
set clipboard=unnamedplus " Sync the unnamed register with the system clipboard

augroup vimrc_clipboard | autocmd!
	autocmd VimEnter * call s:SetupClipboard()
augroup END
function! s:SetupClipboard() "{{{
" Insert mode {{{
	" C-q does what C-v did, insert raw characters
	inoremap <C-q> <C-v>
	" C-v pastes
	if exists('g:loaded_EasyClip') && g:loaded_EasyClip == 1
		" Make sure EasyClip is loaded, otherwise use a fallback
		imap <C-v> <Plug>EasyClipInsertModePaste
	else
		execute 'imap <script> <C-v> <C-g>u' . paste#paste_cmd['i']
	endif
"}}}
" Command mode {{{
	" C-y pastes
	if exists('g:loaded_EasyClip') && g:loaded_EasyClip
		" Make sure EasyClip is loaded, otherwise use a fallback
		cmap <C-y> <Plug>EasyClipCommandModePaste
	else
		cnoremap <C-y> <C-r>+
	endif
"}}}
endfunction "}}}
" yY yanks the line minus the <CR> at the end
" just like dD from EasyClip
nnoremap yY m`0y$``
"}}}

" Data Safety and Managing {{{
set history=1000 " Disk space is REALLY cheap
function! CheckDir(dir) "{{{
	if !isdirectory(a:dir)
		call mkdir(a:dir,"p")
	endif
endfunction "}}}
set fileformats=unix,dos,mac "ALL the formats, by this order

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
augroup vimrc_viminfo | autocmd!
	autocmd VimEnter * call s:SetupViminfo()
augroup END
function! s:SetupViminfo() "{{{
	" Only if there was a setup
	if !exists('g:viminfo_old') || !exists('g:viminfo_new')
		return
	endif

	if filereadable(g:viminfo_old) "Make sure it's there
		" Read the info in the old viminfo file
		execute 'rviminfo!' g:viminfo_old
		call delete(g:viminfo_old)
	endif
	if filereadable(g:viminfo_new) "Make sure it's there
		" This runs after the viminfo is read, so just read it again
		execute 'rviminfo!' g:viminfo_new
	endif
	wviminfo "Merge both files
	rviminfo!

	" Return to status quo
	unlet g:viminfo_old g:viminfo_new
endfunction
"}}}
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
set background=dark "Again, for some reason
if has("syntax")
	syntax enable
endif
set laststatus=2 "Always show the statusline
set hlsearch "Highlight searches ...
nohlsearch "but not when starting up
set sidescroll=1 "Scroll 1 line at a time, horizontally
set scrolloff=5
set sidescrolloff=10
"{{{ Non-Printable Characters
set list "Show non-printable characters
let &listchars = 'tab:  '
"Alternate tab: ≈~
set listchars+=trail:•
set listchars+=precedes:⇇,extends:⇉
set listchars+=nbsp:·
" set listchars+=eol:¶
"}}}
" Numbers {{{
set numberwidth=1 " Minimal width of the number column
set nonumber "No line numbers by default ...
"... but toggle them with:
nnoremap <silent> <Leader>tn :setlocal number!<CR>
"}}}
" Folds {{{
nnoremap <silent> <Leader>tf :call <SID>ToggleFolds()<CR>
function! s:ToggleFolds()
	let l:lvl = foldlevel('.')
	if l:lvl + 1 > &l:foldcolumn
		" Extent the column to the new distance
		let &l:foldcolumn = l:lvl + 1
	else
		if &l:foldcolumn > 0
			set foldcolumn=0
		else
			let &l:foldcolumn = foldlevel('.') + 1
		endif
	endif
endfunction
"}}}
" Cursor Line and Column {{{
set nocursorline nocursorcolumn
nnoremap <silent> <Leader>tc :setlocal cursorline!<CR>
nnoremap <silent> <Leader>tC :setlocal cursorcolumn!<CR>
"}}}
"}}}

" Windowing Systems {{{
augroup vimrc_windowing | autocmd!
	autocmd VimEnter * call s:SetupWindowing()
augroup END
function! s:SetupWindowing()
	if hasmapto('<Plug>ToggleFullScreen')
		nmap <silent> <F11> <Plug>ToggleFullscreen
	endif
endfunction
"}}}

" Navigation {{{
nnoremap <Space> <C-d>
nnoremap <S-Space> <C-u>
nmap g<Space> <S-Space>
nnoremap <silent> <C-Left> :bprevious<CR>
nnoremap <silent> <C-Right> :bnext<CR>
nnoremap <silent> <S-Left> :tabprevious<CR>
nnoremap <silent> <S-Right> :tabnext<CR>
set hidden "Don't prompt when changing buffers
" Alt-jk to move around "{{{
if has('gui_running')
	nnoremap <A-j> <C-e>
	nnoremap <A-k> <C-y>
else
	nnoremap <Esc>j <C-e>
	nnoremap <Esc>k <C-y>
endif
"}}}
"On visual-block let the cursor go to "illegal" places (Half-tabs, past the end, etc)
set virtualedit=block

" "Smart" Apostrophe {{{
nnoremap ' `
nnoremap ` '
"}}}
" "Smart" Zero {{{
nnoremap 0 ^
nnoremap ^ 0
"}}}
" Smart Underscore "{{{
function! SmartUnderscore()
	let l:line = line('.')
	let l:col  = col('.')

	execute 'normal! ^'
	let l:soft = col('.')

	execute 'normal! 0'
	let l:hard = col('.')

	if l:col != l:soft
		call cursor(l:line, l:soft)
	else
		call cursor(l:line, l:hard)
	endif
endfunction
nnoremap <silent> _ :<C-u>call SmartUnderscore()<CR>
"}}}

" Quickfix (q){{{
nnoremap <silent> [q :cprevious<CR>zzzv
nnoremap <silent> ]q :cnext<CR>zzzv
"}}}
" Location list (l){{{
nnoremap <silent> [l :lprevious<CR>zzzv
nnoremap <silent> ]l :lnext<CR>zzzv
"}}}
"}}}

" Diff & Splits {{{
" Diffs {{{
set diffopt+=iwhite "Ignore whitespace on diffs
"}}}
" Splits {{{
set splitright " New splits to the right
set nosplitbelow " New splits on top
"}}}
"}}}

" Search {{{
set ignorecase smartcase "Sane defaults
set incsearch "Start searching right away
" Use <C-l> to clear the highlighting of :set hlsearch.
" <C-l> Already clears the screen, it's just a bonus
" Refresh the statusline too
if maparg('<C-l>', 'n') ==# ''
	nnoremap <silent> <C-l> :nohlsearch<CR>:AirlineRefresh<CR><C-l>
endif
" Center on search
" Make sure it works on folds
nnoremap * *zvzz
nnoremap n nzvzz
nnoremap N Nzvzz
" Don't mess with search directions, n is ALWAYS forward
nmap # *NN
nmap g# g*NN
if exists('g:loaded_visualstar') && g:loaded_visualstar == 1
	xmap # *NN
	xmap g# g*NN
endif
" '&' to repeat last ':s', use flags too
nnoremap & :&&<CR>
xnoremap & :&&<CR>
"}}}

" Mouse {{{
set mouse=a "Enable the mouse in all modes
set selectmode= "But no select mode, ever
set mousemodel=extend "Just like xterm, everywhere
set mousefocus "Move the mouse to switch windows
" But toggle this setting, sometimes it's annoying
nnoremap <silent> <Leader>tm :set mousefocus!<CR>
set mousehide "Hide the pointer when writing
"}}}

" Help {{{
" <F1> for choosing help
nnoremap <F1> :help<Space>
" g<F1> to close the help, regardless of current buffer
if exists(':helpclose') "Newer vim
	nmap <silent> <C-F1> :helpclose<CR>
else
	nmap <silent> <C-F1> <F1><CR><F1>
endif
nmap g<F1> <C-F1>
" <F1> on Insert mode does the same
imap <F1> <C-o><F1>
imap <C-F1> <C-o><C-F1>
"}}}

" Spell {{{
let g:spelling_filetypes = [
			\ 'text',
			\ 'mkd','markdown',
			\ 'gitcommit',
			\ 'help'
			\]
let g:spelling_filetypes_comma = join(g:spelling_filetypes,',')
let g:spelling_filetypes_regex = '\V'.join(g:spelling_filetypes,'\|')
" Toggle spell checking
nnoremap <silent> <Leader>tS :call SpellLoop_ToggleSpell()<CR>
set nospell "Disable it by default
set spelllang=en "Just a sensible default
set spellfile= "Auto-discover
" set spellcapcheck="[.?!]\_[\])'" \t]\+" "Check capitals on start of sentences
set spellsuggest=fast "Works reasonably enough, but it's really fast, especially for English
set spellsuggest+=25 "Show at most this suggestions
let g:loaded_spellfile_plugin = 1 "Don't ask for downloading spellfiles
augroup vimrc_spelling | autocmd!
	" Mark this files as "text"
	execute 'autocmd FileType' g:spelling_filetypes_comma 'call lexical#init({"spell": 1})'
	execute 'autocmd FileType' g:spelling_filetypes_comma 'call SpellLoop_Init()'
	" FIXME: Integrate SpellCheck into syntastic
	execute 'autocmd FileType' g:spelling_filetypes_comma 'nnoremap <silent> <buffer> Q :SpellLCheck!<CR>'
augroup END
"}}}

" Whitespace Management {{{
set autoindent smartindent "Indent in smart, language-specific ways
set shiftround "Align to the nearest "shiftwidth"
" Enter {{{
" On normal mode, Enter put a new line after the current one
nnoremap <silent> <CR> :put =''<CR>
" And S-Enter puts it before
nnoremap <silent> <S-CR> :put! =''<CR>
" Synonym for terminals
nmap g<CR> <S-CR>
"}}}
" Tab {{{
set smarttab "Use 'shiftwidth' with tabs
" Tab to indent text by shiftwidth columns
" C-Tab to indent text by 1 column, using spaces
function! IndentLine(cols)
	if a:cols > 0
		let l:pat = '^'
		let l:subs = repeat(' ',a:cols)
	elseif a:cols < 0
		" The last x spaces, where x < -a:cols
		" If that doesn't match, just ^
		" TODO: Remove tabs?
		let l:pat = '\v^\s{-}\zs {1,'.-a:cols.'}\ze\S|^'
		let l:subs = ''
	else
		return "Do nothing
	endif
	if exists(':keeppatterns')
		let l:keeppatterns = 'keeppatterns'
	else
		let l:keeppatterns = ''
		let l:old_search = @/
	endif
	execute l:keeppatterns 'substitute' '/'.l:pat.'/'.l:subs.'/'
	if empty(l:keeppatterns)
		let @/ = l:old_search
	endif
endfunction
command! -nargs=? -range IndentLine <line1>,<line2>call IndentLine(<f-args>)
nnoremap <Tab> >>
nnoremap <S-Tab>  <<
nnoremap <silent> <C-Tab> :IndentLine 1<CR>
nnoremap <silent> <C-S-Tab>  :IndentLine -1<CR>
nmap g<Tab> <C-Tab>
nmap g<S-Tab> <C-S-Tab>
" On visual mode, keep the indented text select
vnoremap <Tab> >gv
vnoremap <S-Tab>  <gv
vnoremap <C-Tab> :IndentLine 1<CR>gv
vnoremap <C-S-Tab> :IndentLine -1<CR>gv
vmap g<Tab> <C-Tab>
vmap g<S-Tab> <C-S-Tab>
"
"}}}

" Tabularize on Steroids {{{
function! TabularizeThisN()
	if exists('g:tabular_loaded')
		let l:cmd = ':Tabularize'
		if exists('*TabularizeHasPattern') && TabularizeHasPattern()
			" Reuse the last Tabularize command
			let l:cmd .= "\<CR>"
		else
			let l:cmd .= "\<Space>"
		endif
		return l:cmd
	endif
endfunction
nnoremap <silent> <expr> <Leader><Tab> TabularizeThisN()
"}}}
"}}}

" 2Leader Commands{{{
" cd: Change dir to the current file
nnoremap <silent> <Leader><Leader>cd :lcd %:h<CR>:pwd<CR>
" CD: Change dir to current file. Works globally
nnoremap <silent> <Leader><Leader>CD :cd %:h<CR>:pwd<CR>
" b : Show a list of buffers and prompt for a number
nnoremap <silent> <Leader><Leader>b :buffers<CR>:buffer<Space>
" m : Show a list of marks, and prompt for one
nnoremap <silent> <Leader><Leader>m :marks<CR>:mark<Space>
" Vim: Yo dawg, etc {{{
function! s:IsVimRcFile()
	let l:cfull = fnamemodify(expand('%'),':p')
	let l:cdir  = fnamemodify(expand('%'),':p:h')
	let l:cname = fnamemodify(expand('%'),':t')
	if index([expand($MYVIMRC),expand($MYGVIMRC)], l:cfull) != -1
		return 1
	elseif l:cdir ==# g:user_dir && l:cname =~# '\v\Cg?vimrc(\.\w+)?'
		return 1
	else
		return 0
	endif
endfunction
" ve: Edit your vimrc
" vE: Edit your gvimrc
nnoremap <silent> <Leader><Leader>ve :call <SID>vimrc_edit($MYVIMRC)<CR>
nnoremap <silent> <Leader><Leader>vE :call <SID>vimrc_edit($MYGVIMRC)<CR>
" vs: Source your vimrc right here
nnoremap <silent> <Leader><Leader>vs :call <SID>vimrc_write() <Bar> source $MYVIMRC<CR>:AirlineRefresh<CR>
function! s:vimrc_edit(vimrc)
	if expand('%:p') ==# expand(a:vimrc)
		return
	endif
	execute IsEmptyBuffer() ? 'edit' : 'tabnew' a:vimrc
endfunction
function! s:vimrc_write()
	if s:IsVimRcFile()
		silent write
	endif
endfunction
"}}}
"}}}

" Plugin Configuration {{{
" CtrlP {{{
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20'
let g:ctrlp_clear_cache_on_exit = 0 "Cache the results, F5 to purge
let g:ctrlp_open_new_file = 'r' "Create new files in the current window
let g:ctrlp_open_multiple_files = '1i' "Open multi files in hidden buffers
let g:ctrlp_key_loop = 0 "Multi-byte keys (eg. tilde in PT keyboard)
let g:ctrlp_mruf_exclude = '\v\.git(/|\\)'
let g:ctrlp_mruf_max = 500 "files to remember
let g:ctrlp_mruf_exclude_nomod = 0 "Only mofiable files
let g:ctrlp_tilde_homedir = 1
let g:ctrlp_reuse_window = 'startify' "buftypes to overwrite
nnoremap <silent> <C-b> :CtrlPMRUFiles<CR>
" Mappings {{{
" F2 toggles MRU in current directory
let g:ctrlp_prompt_mappings = {
			\ 'ToggleMRURelative()': ['<F2>'],
			\}
"}}}
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
" CtrlPFunky{{{
nnoremap <silent> <Leader>f :CtrlPFunky<CR>
let g:ctrlp_funky_after_jump = 'zvzz' "Open folds and center on screen
let g:ctrlp_funky_multi_buffers = 1 "Not just the current buffer
let g:ctrlp_funky_syntax_highlight = 1 "Might not work flawlessly
let g:ctrlp_funky_use_cache = 0 "It's fast enough, I think
" let g:ctrlp_funky_cache_dir = OS_specific
let g:ctrlp_funky_matchtype = 'path'
" Filetypes "{{{
let g:ctrlp_funky_php_requires = 1
let g:ctrlp_funky_php_include = 1
let g:ctrlp_funky_ruby_access = 1
let g:ctrlp_funky_ruby_classes = 1
let g:ctrlp_funky_ruby_modules = 1
"}}}
"}}}
"}}}
" NERDTree {{{
nnoremap <silent> <F2> :NERDTreeFocus<CR>
nnoremap <silent> <C-F2> :NERDTreeClose<CR>
nmap g<F2> <C-F2>
nnoremap <silent> <S-F2> :NERDTreeCWD<CR>
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeHighlightCursorline = 1
let g:NERDTreeHijackNetrw = 1 "Open secondary trees for :e $folder
let g:NERDTreeAutoCenterThreshold = 1 "Auto-center when shifting between folder levels
let g:NERDTreeMouseMode = 3 "Single-click to open file and folders
let g:NERDTreeMinimalUI = 1 "No help and bookmark headers
let g:NERDTreeCascadeOpenSingleChildDir = 1
" let g:NERDTreeBookmarksFile = OS_specific
" NERDTreeTabs{{{
let g:nerdtree_tabs_open_on_gui_startup = 0 "Don't auto-open
let g:nerdtree_tabs_open_on_console_startup = 0 "EVER
"}}}
"}}}
" Airline {{{
	" Customization
function! GetCurrentFunctionName()
	return cfi#format("%s","")
endfunction
function! GetCurrentSpellingLanguage()
	return toupper(''.&spelllang)
endfunction
function! s:vimrc_airline_config()
	" Funcname: Use cfi
	call airline#parts#define_function('funcname', 'GetCurrentFunctionName')
	call airline#parts#define_accent('funcname', 'bold')
	" Spell: As simple as possible
	call airline#parts#define_function('spelling', 'GetCurrentSpellingLanguage')
	call airline#parts#define_accent('spelling', 'bold')
	call airline#parts#define_condition('spelling', '&spell')
	" CursorLocation: Big complex and complete
	call airline#parts#define_raw('cursorloc', '%P:%L|%#__accent_bold#%-4l%{g:airline_symbols.linenr}%2v%#__restore__#')
	"----------------------
	" Sections: Define them
	let g:airline_section_x = airline#section#create_right(['spelling','funcname','filetype'])
	let g:airline_section_z = airline#section#create(['wordcount','cursorloc'])
endfunction
augroup vimrc_airline | autocmd!
	autocmd User AirlineAfterInit call s:vimrc_airline_config()
augroup END
	" Tabline
let g:airline#extensions#tabline#enabled = 1 "Show a tabline
let g:airline#extensions#tabline#show_buffers = 1 "If there's only one tab, show the buffers
let g:airline#extensions#tabline#buffer_min_count = 2 "But only if there's more than 1
let g:airline#extensions#tabline#tab_nr_type = 1 "Show tabnumbers
let g:airline#extensions#tabline#formatter = 'unique_tail_improved' "Uniquify filenames
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#hunks#non_zero_only = 1 "Don't show changes if there's none
	" Whitespace
let g:airline#extensions#whitespace#symbol = '₩'
let g:airline#extensions#whitespace#checks = ['indent', 'trailing', 'long']
let g:airline#extensions#whitespace#trailing_format = 'T[%s]'
let g:airline#extensions#whitespace#mixed_indent_format = 'M[%s]'
let g:airline#extensions#whitespace#long_format = 'L[%s]'
" Wordcount
let g:airline#extensions#wordcount#enabled = 1
let g:airline#extensions#wordcount#filetypes = g:spelling_filetypes_regex
let g:airline#extensions#wordcount#format = '%sW'
" Appearance
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇ '
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
"}}}
"{{{ Bufferline
let g:bufferline_echo = 0 "No echo on command line
let g:bufferline_rotate = 1 "Keep the current buffer name visible
"}}}
" Git Gutter{{{
let g:gitgutter_max_signs = 1000 "Ignore big diffs
nmap [c <Plug>GitGutterPrevHunkzzzv
nmap ]c <Plug>GitGutterNextHunkzzzv
"}}}
" Syntastic {{{
" Check if there's any syntax errors
nnoremap <silent> Q :SyntasticCheck<CR>:Errors<CR>
let g:syntastic_enable_signs = 1 "Don't put signs on lines, that's for Git Gutter
let g:syntastic_auto_loc_list = 2 "Close loclist if there's no errors, but don't open automatically
let g:syntastic_check_on_open = 1 "Check when opening and saving
let g:syntastic_check_on_wq = 0 "Not when leaving
let g:syntastic_loc_list_height = 5
" File Types {{{
let g:syntastic_python_checkers = ["python","pylint","flake8","pep8"]
"}}}
"}}}
" SuperTab {{{
" Smarter completion
" Real fallback is the old regular keyword completion
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = '<C-p>'
function! s:vimrc_supertab_configure()
	if &omnifunc != ''
		call SuperTabChain(&omnifunc, g:SuperTabContextDefaultCompletionType)
		if exists('b:supertab_chain_default') && b:supertab_chain_default == 1
			call SuperTabSetDefaultCompletionType("<C-x><C-u>")
		endif
	endif
endfunction
augroup vimrc_supertab_chain | autocmd!
	" See supertab-completionchaining
	" This filetypes will have omnifunc override the context completion
	autocmd FileType css,sql,php let b:supertab_chain_default = 1
	" By default, don't override
	autocmd FileType * call s:vimrc_supertab_configure()
augroup END
" Each completion is a different beast
let g:SuperTabRetainCompletionDuration = 'completion'
" Insert completion, write more, and Tab again to re-complete
" But don't pre-select the first value. This works like wildmode, mostly
let g:SuperTabLongestEnhanced = 1
let g:SuperTabLongestHighlight = 0
" C-Tab to do full line completion
let g:SuperTabSkipMappingTabLiteral = 1
imap <C-Tab> <C-x><C-l>
"}}}
" Markdown @ plasticboy {{{
let g:vim_markdown_math = 1 "LaTeX math inside $$
let g:vim_markdown_frontmatter = 1 "YAML frontmatter e.g Jekyll
"}}}
" Signature {{{
let g:SignatureMarkTextHLDynamic = 1 "Integrate with vim-gitgutter
"}}}
" Speed Dating {{{
set nrformats-=octal "Messes stuff up
"}}}
" EasyClip {{{
" Setup Shared Yanks {{{
" This must be here so that the multi OS config is kept simple
function! s:SetupEasyClipShared()
	"Yank history across vim sessions
	let g:EasyClipShareYanks = 1
	" Reload the Shared file
	call EasyClip#Shared#Init()
endfunction
augroup vimrc_easyclip | autocmd!
	autocmd VimEnter * call s:SetupEasyClipShared()
augroup END
"}}}
let g:EasyClipShareYanksFile = 'EasyClip.yanks'
" let g:EasyClipShareYanksDirectory = OS_specific
let g:EasyClipYankHistorySize = 500 "Disk space is cheap
let g:EasyClipPreserveCursorPositionAfterYank = 1 "Consistency with other operators be damned!
let g:EasyClipAutoFormat = 1 "Auto-format pasted text ...
" But press a key combination to toggle between formatted and unformatted text
nmap <Leader>cf <Plug>EasyClipToggleFormattedPaste
"" Keybidings
let g:EasyClipUseCutDefaults = 0 "Cut text, don't alias marks
nmap x  <Plug>MoveMotionPlug
xmap x  <Plug>MoveMotionXPlug
nmap X  <Plug>MoveMotionPlug$
nmap xx <Plug>MoveMotionLinePlug
" Keep the original 'x' action using Backspace
nnoremap <BS> "_X
nnoremap <S-BS> "_x
nmap g<BS> <S-BS>
let g:EasyClipUseSubstituteDefaults = 0 "Use s<motion> to replace texts
nmap s  <Plug>SubstituteOverMotionMap
nmap S  <Plug>SubstituteOverMotionMap$
nmap ss <Plug>SubstituteLine
let g:EasyClipUsePasteToggleDefaults = 0 " Paste and rotate the yank ring
nmap <C-d> <Plug>EasyClipSwapPasteBackwards
"}}}
" EasyMotion {{{
let g:EasyMotion_verbose = 0
" User <Space> or <CR> to jump to first match
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1
let g:EasyMotion_grouping = 1 " Prioritize single-keys
let g:EasyMotion_use_upper = 1 " Show uppercase but type lowercase
let g:EasyMotion_keys = 'JKHLASDFGQWERZXCVTYUIOPBNM,.-1234567890' " The markers to use
" Mappings {{{
" `map` for n,x(v,s),o mode all at once
map <Leader><Leader>s <Plug>(easymotion-prefix)
let g:EasyMotion_do_mapping = 1 " Map everything with a weirdo prefix, just in case
"             's' is f and F rolled into one, on steroids!
"            's2' is 's', but asking for 2 characters to narrow it down
"          'bd-t' is t, but bidirectional
"         'bd-jk' is choose the line to jump to
"'jumptoanywhere' is just that, customizable
map <C-f> <Plug>(easymotion-s)
map <C-t> <Plug>(easymotion-bd-t)
map <C-j> <Plug>(easymotion-bd-jk)
map <C-k> <Plug>(easymotion-bd-jk)
map <Leader>s <Plug>(easymotion-jumptoanywhere)
map <Leader>S <Plug>(easymotion-s2)
"}}}
" Appearance {{{
" hi link EasyMotionShade         Comment
" hi link EasyMotionTarget        IncSearch
" hi link EasyMotionTarget2First  MatchParen
" hi link EasyMotionTarget2Second MatchParen
"}}}
"}}}
" Visualstar {{{
let g:visualstar_folds = 1 "Open current fold on search
let g:visualstar_center_screen = 1 "Center screen after searching
"}}}
" LineDiff "{{{
let g:linediff_first_buffer_command  = 'rightbelow new'
let g:linediff_second_buffer_command = 'rightbelow vertical new'
vnoremap <silent> <Leader>d :Linediff<CR>
autocmd User LinediffBufferReady
	\ nnoremap <silent> <buffer> <Leader>d :LinediffReset<CR>
"}}}
" Indent Guides {{{
let g:indent_guides_default_mapping = 0
nmap <silent> <Leader>tg <Plug>IndentGuidesToggle
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 0 "Fat guides
"}}}
" Extradite {{{
nnoremap <silent> <F3> :Extradite!<CR>
nmap <C-F3> <Plug>ExtraditeClose
nmap g<F3> <C-F3>
let g:extradite_width = 100 "Characters
let g:extradite_showhash = 1 "Abbreviate commit hashes
"}}}
" AutoClose @ Townk {{{
let g:AutoClosePreserveDotReg = 0 "Don't map ESC in insert mode!
let g:AutoCloseSmartQuote = 1 "Don't close quotes when preceeded by an odd number of '\'
let g:AutoCloseExpandSpace = 1 "Space puts a space inbetween delimiters
let g:AutoCloseExpandEnterOn = '' "Don't even map the enter key, that's for Endwise
let g:AutoCloseSelectionWrapPrefix = '<Leader>w'
nnoremap <silent> <Leader>tp :AutoCloseToggle<CR>
augroup vimrc_autoclose | autocmd!
	autocmd VimEnter * let g:AutoClosePairs = AutoClose#ParsePairs('() [] {} " '' `')

	autocmd FileType vim  let b:AutoClosePairs = AutoClose#DefaultPairsModified('', '"')
	autocmd FileType help let b:AutoClosePairs = AutoClose#DefaultPairsModified('* |', '')
	autocmd FileType ruby let b:AutoClosePairs = AutoClose#DefaultPairsModified('|', '')
	autocmd FileType html let b:AutoClosePairs = AutoClose#DefaultPairsModified('<>','')
	autocmd FileType mkd,mkd.markdown,markdown let b:AutoClosePairs = AutoClose#DefaultPairsModified('*','')
augroup END
"}}}
"Filetype - SQL {{{
let g:omni_sql_no_default_maps = 1 "No <C-c> etc mappings
"}}}
" Lexical {{{
let g:lexical#spell = 0 "Disable spelling by default...
"}}}
" SpellCheck @ Ingo Karkat "{{{
let g:SpellCheck_DefineAuxiliaryCommands = 0 "Only the :SpellCheck command
let g:SpellCheck_OnNospell = '' "SpellCheck command fails when 'spell' is off
"}}}
" Spell Loop "{{{
let g:spellloop_quiet = 1 " Don't echo a message everytime the language changes
let g:spellloop_skip_nospell = 1 " Don't loop if 'spell' is not set
let g:spell_list = ['en_gb','pt',]
let &spelllang = g:spell_list[0]
nnoremap <silent> <Leader>ts :call SpellLoop()<CR>
"}}}
" SnipMate {{{
let g:snips_author = 'somini'
let g:snips_no_mappings = 1 "Don't map anything
let g:snipMate = {}
let g:snipMate['no_match_completion_feedkeys_chars'] = '' "Don't insert nothing if there's no snippet found
" Set <C-Space> as the de-facto snippets key
imap <C-Space>   <Plug>snipMateNextOrTrigger
imap <C-S-Space> <Plug>snipMateBack
imap <C-r><Tab>  <Plug>snipMateShow
vmap <C-Space>   <Plug>snipMateVisual
" On terminals, set <C-c> as a fallback
" Alias leaving insert mode without triggering autocmd, should be good
imap <C-c>      <Plug>snipMateNextOrTrigger
imap <C-g><C-c> <Plug>snipMateBack
vmap <C-c>      <Plug>snipMateVisual
"}}}
" Startify {{{
let g:startify_custom_footer =[
			\ ''                                                      ,
			\ '   [l]  Open marked/current files. Equivalent to <CR>' ,
			\ '   [e]  New empty buffer, Normal mode'                 ,
			\ '   [i]  New empty buffer, Insert mode'                 ,
			\ '   [q]  Quit '                                         ,
			\ ]
let g:startify_list_order = [
			\ ['My Bookmarks']             ,
			\ 'bookmarks'                  ,
			\ ['Most Recently Used files'] ,
			\ 'files'                      ,
			\ ['Current Directory']        ,
			\ 'dir'                        ,
			\ ['Sessions']                 ,
			\ 'sessions'                   ,
			\ ]
let g:startify_enable_special = 0
let g:startify_files_number = 15
let g:startify_relative_path = 1
" Use the EasyMotion keys as custom indices
" Filter those already mapped by Startify (see Best Practices)
" Also filter my own mappings
let g:startify_custom_indices = filter(
			\ split(tolower(g:EasyMotion_keys),'.\zs'),
			\ 'v:val !~# "[eiqbstvjk l]"')
function! s:vimrc_startify()
	" It's easier to identify the file names
	setlocal cursorline
	" Mimic nerdtree horizontal mappings, for consitency
	nmap <buffer> l <Plug>(startify-open-buffers)
	" Custom highlight
	highlight link StartifyHeader  Comment
	highlight link StartifyFooter  Comment
endfunction
augroup vimrc_startify | autocmd!
	autocmd User Startified call s:vimrc_startify()
augroup END
"}}}
"}}}

" Modeline {{{
" vim:ft=vim:ts=2:sw=2:fdm=marker
"}}}
