" presentation
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
set backspace=indent,eol,start " 'normal' backspace behavior

" searching
set incsearch		" search as you type
set hlsearch		" highlight all search results
set magic		" special characters available in pattern matching
set ignorecase		" ignore case in searching
"set smartcase		" only use case sensitive search when capitals are included in

" spellcheck
autocmd Filetype text setlocal spell spelllang=en_us	" turn on spell check for text files only
" hi SpellLocal ctermbg=DarkMagenta
" hi SpellRare ctermbg=DarkMagenta
hi SpellLocal ctermbg=Black 				" invisible or innocuous with dark themes
set spellcapcheck=					" turn off capitalization check. too bad this doesn't exist for SpellLocal

" custom date insert command
command! Date put =strftime('%Y-%m-%d')

" github.com/junegunn/vim-plug
" run :PlugInstall / :PlugClean after changing plugin lists
" below are github vim plugin projects
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-speeddating'	"mods ctrl+x and ctrl+a to work with dates
Plug 'tpope/vim-eunuch'		"simple file operations, namely :Delete, which is useful when reviewing a large number of files

call plug#end()
