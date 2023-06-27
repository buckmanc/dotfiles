
" presentation
set background=dark	" better colors for dark themes
syntax on		" syntax highilghting
set ruler		" show cursor position
set number		" show line numbers
set showmatch		" bracket matching
set wildmenu		" command line tab completion
set breakindent		" visual indenting 
set linebreak		" do not visually break lines in the middle of words

" behaviour
set autoindent		" copy indenting from current line
set smartindent 	" smart indenting for coding
set autoread		" reloads file only if unmodified in vim
set novisualbell	" stop yelling at me
set noerrorbells	" i'm serious
set wildignorecase	" ignore case when tab completing paths
set backspace=indent,eol,start	" 'normal' backspace behavior
set undodir=~/.vim/undodir	" where to save undo history
set undofile			" enable persistent undo

" searching
set incsearch		" search as you type
set hlsearch		" highlight all search results
set magic		" special characters available in pattern matching
set ignorecase		" ignore case in searching
set smartcase		" only use case sensitive search when capitals are included in

" spellcheck
autocmd Filetype text setlocal spell spelllang=en_us	" turn on spell check for text files only
" hi SpellLocal ctermbg=DarkMagenta
" hi SpellRare ctermbg=DarkMagenta
hi SpellLocal ctermbg=Black 				" invisible or innocuous with dark themes
set spellcapcheck=					" turn off capitalization check. too bad this doesn't exist for SpellLocal

" custom date insert command
command! Date put =strftime('%Y-%m-%d')

"hi StatusLine ctermbg=black ctermfg=black " doesn't work right on mobile

augroup FileTypeSpecificAutocommands
	autocmd FileType cs setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
augroup end

" wrapping in a try catch as plugins are completely broken on some systems
try
	" github.com/junegunn/vim-plug
	" run :PlugInstall / :PlugClean after changing plugin lists
	" below are github vim plugin projects
	call plug#begin('~/.vim/plugged')

	Plug 'tpope/vim-speeddating'	"mods ctrl+x and ctrl+a to work with dates
	Plug 'tpope/vim-eunuch'		"simple file operations, namely :Delete, which is useful when reviewing a large number of files

	call plug#end()
catch

endtry

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
