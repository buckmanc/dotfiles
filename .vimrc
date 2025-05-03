" nocompatible resets a few things when set
" so only set if needed
if &compatible
	set nocompatible
endif

" not for vim.tiny
if has("eval")
	syntax on		" syntax highlighting
endif

" presentation
set background=dark	" better colors for dark themes
set ruler		" show cursor position
set number		" show line numbers
set showmatch		" bracket matching
set t_Co=256		" no really we have colors here (for airline on certain platforms)
set notitle		" don't update the window title
" experimental

set tabstop=4 shiftwidth=4 softtabstop=4

" behaviour
set breakindent		" visual indenting
set linebreak		" do not visually break lines in the middle of words
set autoindent		" copy indenting from current line
set smartindent 	" smart indenting for coding
set autoread		" reloads file only if unmodified in vim
set novisualbell	" stop yelling at me
set noerrorbells	" i'm serious
set wildmenu		" command line tab completion
set wildignorecase	" ignore case when tab completing paths
set whichwrap+=<,>,h,l	" allow moving to next line from the ends
set backspace=indent,eol,start	" 'normal' backspace behavior
set mouse=		" disable mouse/touch controls
set clipboard=		" unjoin from system clipboard on windows for consistent cross-platform behaviour
set viminfo+=!		" make sure it can save viminfo
set viminfo-=<50	" unlimited saved register size

" not for vim.tiny
if has("eval")
	" problematic behaviour
	" these setting vars are comma delineated
	" which means any paths assigned to them need to have the commas escaped
	" you're right, commas should *never* be in your home dir
	" but some things cannot be controlled
	let vimDirCommaless=escape(expand("~/.vim/"), ',')
	let &undodir=vimDirCommaless . 'undodir'	" where to save undo history
	set undofile			" enable persistent undo
	let &backupdir=vimDirCommaless . 'backupdir'  " backups
	set backup
	let &directory=vimDirCommaless . 'swap'
endif

" filenames can have space, comma, ampersand... sigh
set isfname+=32
set isfname+=38
set isfname+=44

" searching
set incsearch		" search as you type
set hlsearch		" highlight all search results
set magic		" special characters available in pattern matching
set ignorecase		" ignore case in searching
set smartcase		" only use case sensitive search when capitals are included in
set infercase		" infer completion case
set report=0		" always show 'x lines changed' messages
set commentstring=#%s	" default comment string, is changed downstream as needed

" performance improvment experiment
" set lazyredraw
" autocmd VimEnter * redraw!

" color tweaks
" fewer screaming colors
" designed to match with base16 Midnight Synth terminal theme
hi! TODO	ctermbg=green
" hi SpellRare	ctermbg=DarkMagenta
hi SpellLocal	ctermbg=235
hi SpellBad	ctermbg=240
" hi Search	cterm=reverse term=reverse gui=reverse ctermbg=none ctermfg=none
hi  Search	ctermfg=0 ctermbg=9 " cterm=reverse no longer works
hi! MatchParen	cterm=underline ctermbg=none ctermfg=none
hi! Error	ctermbg=darkred
hi! normal	ctermbg=none	" don't wipe out terminal backgrounds
hi! EndOfBuffer	ctermbg=none
hi! NonText	ctermbg=none
hi! link IncSearch Search
hi! link ErrorMsg Error

" spellcheck
set spellcapcheck=	" turn off capitalization check. too bad this doesn't exist for SpellLocal
set spellsuggest+=10	" limit spell suggest for small screens

" not for vim.tiny
if has("eval")
	" iterate over custom spellfiles
	let spellPaths = ''
	for d in glob('~/.vim/spell/*.add', 1, 1)
		if (filereadable(d))

			" compile the file if needed
			if (!filereadable(d . '.spl') || getftime(d) > getftime(d . '.spl'))
				echo 'compiling spell file updates: ' . d
				silent exec 'mkspell! ' . fnameescape(d)
			endif

			" append the file path to the list

			" spellfile is comma delineated
			" so commas in the paths must be escaped
			" can't escape earlier as it breaks file system functions
			let d = escape(d, ',')

			if (len(spellPaths) == 0)
				let spellPaths=fnameescape(d)
			else
				let spellPaths=spellPaths . "," . fnameescape(d)
			endif

			" echo d
			" echo spellPaths
		endif

		" update the spell file setting
		exec 'set spellfile=' . spellPaths
	endfor

	" custom date insert command
	" accepts an integer date offset
	function DateStampFunc(...)
		let days = get(a:, 1, 0)
		let daySeconds = days * 24 * 60 * 60
		return strftime('%Y-%m-%d', ( localtime() + daySeconds ))
	endfunction

	function! GitAddMeFunc(bang)
		" write if changed
		:update

		if a:bang == 0
			" echo "regular add"
			Git add %:p
		else
			" echo "force add"
			Git add --force %:p
		endif
		" echo a:bang
	endfunction

	function BaShebang()
		" don't add a shebang to 
		" .bashrc, .bash_alias, etc
		if expand("%:t") =~ '^\.bash'
			return
		endif
		silent! ShebangInsert bash
	endfunction

	command -bar -nargs=? Date put =DateStampFunc(<args>)
	command RunMe update | !"%:p"
	" TODO: throws "too many args" when called more than once after writing changes on the first run
	command -bang GitAddMe :call GitAddMeFunc(<bang>0)

	" create some internal dirs if they don't exist
	" with support for multiple values
	" and escaped commas
	let dirsToMake=&undodir . ',' . &backupdir . ',' . &directory

	" split on comma not preceded by backslash
	for dir in split(dirsToMake, '\(\\\)\@<!,')
		" unescape the path
		let dir = substitute(dir, '\\,', ',', 'g')

		" mkdir if it doesn't exist
		if !isdirectory(dir)
			call mkdir(dir, "p")
		endif
	endfor
endif

if has('autocmd')
augroup FileTypeSpecificAutocommands

	" autocommand filetypes
	" makes sure these filetypes have appropriate syntax highlighting and comment chars
	autocmd BufNewFile,BufRead *.gitconfig_local set filetype=gitconfig
	autocmd BufNewFile,BufRead *.vimrc_local set filetype=vim
	autocmd BufNewFile,BufRead *.bash_* set filetype=bash
	autocmd BufNewFile,BufRead *.add set filetype=text
	autocmd BufNewFile,BufRead *.vssettings set filetype=xml
	autocmd BufNewFile,BufRead *.gui set filetype=xml
	autocmd BufNewFile,BufRead *.hlsl set filetype=c
	autocmd BufNewFile,BufRead *.MD set filetype=markdown " uppercase markdown is still markdown

	" autocommand actions
	autocmd FileType cs setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
	autocmd FileType markdown,text setlocal keywordprg=dict
	autocmd Filetype markdown,text setlocal spell spelllang=en_us	" turn on spell check
	autocmd FileType text hi Search ctermfg=magenta " text theme is white, so reverse search colors make white cursor painful
	autocmd BufRead,BufNewFile ~/bin*/* silent! ShebangInsert bash
	" if this gets annoying, use a function with an "if filereadable(expand('%'))" test to check for newness
	" file type and BufNewFile autocommands cannot be combined
	autocmd FileType sh,python silent! ShebangInsert
	autocmd FileType bash call BaShebang()

	" doesn't work
	" autocmd FileChangedRO * echohl WarningMsg | echo "read-only file" | echohl None
	" works but disables the readonly flag entirely
	" autocmd! InsertEnter * if &readonly | set noreadonly | endif

augroup end

" auto reload vimrc on save
augroup myvimrc
	au!
	" using silent here as the update called in GitAddMeFunc causes this to throw an error
	au BufWritePost .vimrc silent! source $MYVIMRC
endif " has('autocmd')

" github.com/junegunn/vim-plug
" run :PlugInstall / :PlugClean after changing plugin lists
if filereadable(expand("~/.vim/plug.vim"))
	" explicitly source plug
	" as auto plugin loading is broken on certain platforms
	source ~/.vim/plug.vim

	" plugins
	call plug#begin('~/.vim/plugged')

	Plug 'tpope/vim-sensible'	" tpope's sensible defaults
	Plug 'tpope/vim-sleuth'		" hueristic file options
	Plug 'tpope/vim-speeddating'	" mods ctrl+x and ctrl+a to work with dates
	Plug 'tpope/vim-eunuch'		" simple file operations, namely :Delete and :SudoWrite
	Plug 'tomtom/tcomment_vim'	" gcc/gc to comment
	Plug 'vim-airline/vim-airline'	" fancy status line
	Plug 'vim-airline/vim-airline-themes'
	" Plug 'airblade/vim-gitgutter'	" git in the gutter, freezing on excessively large repos
	Plug 'mhinz/vim-signify'	" git in the gutter
	Plug 'tpope/vim-fugitive'		" git commands, namely :Git add
	Plug 'preservim/vim-markdown'	" improved markdown syntax
	Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }	" intellisense
	" Plug 'sirver/ultisnips'
	Plug 'editorconfig/editorconfig-vim'
	Plug 'jlcrochet/vim-razor'	" razor syntax
	Plug 'datamadsen/vim-compiler-plugin-for-dotnet'
	Plug 'tpope/vim-dispatch'	" async :Make
	Plug 'mhinz/vim-startify'	" startup screen
	" Plug 'sbdchd/vim-shebang'	" :ShebangInsert
	Plug 'buckmanc/vim-shebang', { 'branch': 'blank_line_dev' }
	Plug 'glensc/vim-syntax-lighttpd'

	call plug#end()


	" airline config
	set noshowmode			" airline shows mode
	" let g:airline_theme='simple' " works well enough with differing terminal themes
	" let g:airline_theme='distinguished'
	" let g:airline_theme='minimalist' " real good but a little hard to read
	" let g:airline_theme='monochrome' " as simple as it gets
	let g:airline_theme='raven'
	let g:airline_powerline_fonts = 1
	" let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
	let g:airline#extensions#tabline#formatter = 'unique_tail'
	let g:airline_section_c_only_filename = 1

	let g:airline_detect_spell=0
	let g:airline_skip_empty_sections = 1
	let g:airline_section_z = '%p%%%'
	let g:airline#extensions#hunks#enabled=0	" turn off changes, leave only branch name in section b
	let g:airline_whitespace_checks= [ 'indent', 'trailing', 'mixed-indent-file', 'conflicts' ]
	" fix airline delay on mode change
	" affects gcc command
	" set timeoutlen=500

	" < 80 mobile landscape
	" < 40 mobile portrait
	let g:airline#extensions#default#section_truncate_width = {
	\ 'a': 0,
	\ 'b': 80,
	\ 'c': 0,
	\ 'x': 40,
	\ 'z': 80,
	\ 'warning': 40,
	\ 'error': 40,
	\ 'wordcount': 0,
	\ }

	let g:airline#extensions#default#layout = [
	\ [ 'a', 'b', 'c' ],
	\ [ 'x', 'y', 'z', 'error', 'warning' ]
	\ ]

	" gitgutter/signify config
	" wipe the conspicuous colors from the gutter
	hi LineNr	ctermfg=darkblue
	hi SignColumn	ctermbg=NONE cterm=NONE guibg=NONE gui=NONE
	hi! DiffChange	ctermfg=darkmagenta ctermbg=none
	hi! link DiffAdd DiffChange
	hi! link DiffDelete DiffChange

	" let g:gitgutter_diff_args = '-w'  " ignore whitespace changes
	let g:signify_sign_change = '~'
	let g:signify_vcs_cmds = {
				\ 'git': 'git diff -w --no-color --no-ext-diff -U0 -- %f' }

	" ycm config
	" let g:ycm_auto_hover="
	" aggressively trigger semantic completion
	" let g:ycm_semantic_triggers =  {
	" 			\   'c,cs,cpp,objc': [ 're!\w{3}', '_' ],
	" 			\ }

	" misc/obvi config
	let g:vim_markdown_folding_disabled = 1
	let g:dotnet_compiler_errors_only = 1
	" let g:plug_window = '0tabnew'
	let g:plug_window = 'enew'

	" ycm suggested ultisnips remappings
	" UltiSnips triggering :
	"  - ctrl-j to expand
	"  - ctrl-j to go to next tabstop
	"  - ctrl-k to go to previous tabstop
	" let g:UltiSnipsExpandTrigger = '<C-j>'
	" let g:UltiSnipsJumpForwardTrigger = '<C-j>'
	" let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

	let g:shebang#blank_line = 1
	let g:shebang#shebangs = {
				\ 'sh': '#!/usr/bin/env bash',
				\ 'termux': '#!/data/data/com.termux/files/usr/bin/bash'
				\ }
endif " vim-plug exists

" default position restoration from /etc/vim/vimrc
" au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" the below is the position restoration stolen from /etc/vim
" via git for Windows (git-extra/vimrc)
"
" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Set UTF-8 as the default encoding for commit messages
    autocmd BufReadPre COMMIT_EDITMSG,MERGE_MSG,git-rebase-todo setlocal fileencoding=utf-8

    " Remember the positions in files with some git-specific exceptions"
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$")
      \           && &filetype !~# 'commit\|gitrebase'
      \           && expand("%") !~ "ADD_EDIT.patch"
      \           && expand("%") !~ "addp-hunk-edit.diff" |
      \   exe "normal! g`\"" |
      \ endif

      autocmd BufNewFile,BufRead *.patch set filetype=diff

      autocmd Filetype diff
      \ highlight WhiteSpaceEOL ctermbg=red |
      \ match WhiteSpaceEOL /\(^+.*\)\@<=\s\+$/
endif " has("autocmd")

if filereadable(expand('~/.vimrc_local'))
	source ~/.vimrc_local
endif
