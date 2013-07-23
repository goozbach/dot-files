colorscheme desert
set wm=5 ai

set tabstop=4	"An indentation level every 4 columns"
set expandtab	"Convert all tabs typed into spaces"
set shiftwidth=4	"Indent/outdent by 4 columns"
set shiftround	"Always indent/outdent to nearest tabstop"
set smartindent


" set foldlevel=0
" set foldmethod=marker
" set foldcolumn=3

filetype plugin on
filetype indent on

""Linux-Mandrake configuration.
"Chmouel Boudjnah <chmouel@mandrakesoft.com>

"Syntax highlighting only for enhanced-vi
if has("terminfo")
    syntax on
endif

if &t_Co > 1 
  syntax on
  set guifont=DejaVu\ Sans\ Mono\ 9
  highlight Normal guibg=black guifg=lightgreen 
  highlight Search NONE
endif


"Display a status-line
set statusline=~

"Default backspace like normal
set bs=2

"Terminal for 80 char ? so vim can play till 79 char.
set textwidth=75

"Some option desactivate by default (remove the no).
set nobackup
set nohlsearch
set noincsearch


"Show the position of the cursor.
set ruler

"Show matching parenthese.
set showmatch

"" Gzip and Bzip2 files support
" Take from the Debian package and the exemple on $VIM/vim_exemples
if has("autocmd")

" Set some sensible defaults for editing C-files
augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For *.c and *.h files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd BufRead *       set formatoptions=tcql nocindent comments&
  autocmd BufRead *.c,*.h set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
augroup END

" Also, support editing of gzip-compressed files. DO NOT REMOVE THIS!
" This is also used when loading the compressed helpfiles.
augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.gz set bin
  autocmd BufReadPre,FileReadPre	*.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost	*.gz set nobin
  autocmd BufReadPost,FileReadPost	*.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . %:r

  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  autocmd FileAppendPre			*.gz !gunzip <afile>
  autocmd FileAppendPre			*.gz !mv <afile>:r <afile>
  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  autocmd FileAppendPost		*.gz !gzip <afile>:r
augroup END

augroup bzip2
  " Remove all bzip2 autocommands
  au!

  " Enable editing of bzipped files
  "       read: set binary mode before reading the file
  "             uncompress text in buffer after reading
  "      write: compress file after writing
  "     append: uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre        *.bz2 set bin
  autocmd BufReadPre,FileReadPre        *.bz2 let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost      *.bz2 set cmdheight=2|'[,']!bunzip2
  autocmd BufReadPost,FileReadPost      *.bz2 set cmdheight=1 nobin|execute ":doautocmd BufReadPost " . %:r
  autocmd BufReadPost,FileReadPost      *.bz2 let &ch = ch_save|unlet ch_save

  autocmd BufWritePost,FileWritePost    *.bz2 !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost    *.bz2 !bzip2 <afile>:r

  autocmd FileAppendPre                 *.bz2 !bunzip2 <afile>
  autocmd FileAppendPre                 *.bz2 !mv <afile>:r <afile>
  autocmd FileAppendPost                *.bz2 !mv <afile> <afile>:r
  autocmd FileAppendPost                *.bz2 !bzip2 -9 --repetitive-best <afile>:r
augroup END

endif " has ("autocmd")

"====[ Edit and auto-update this config file and plugins ]==========

augroup VimReload
autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

nmap <silent>  ;v   [Edit .vimrc]          :next $MYVIMRC<CR>
nmap           ;vv  [Edit .vim/plugin/...] :next $HOME/.vim/plugin/



"====[ Use persistent undo ]=================

if has('persistent_undo')
    " Save all undo files in a single location (less messy, more risky)...
    set undodir=$HOME/tmp/.VIM_UNDO_FILES

    " Save a lot of back-history...
    set undolevels=5000

    " Actually switch on persistent undo
    set undofile

endif


"====[ Goto last location in non-empty files ]=======

autocmd BufReadPost *  if line("'\"") > 1 && line("'\"") <= line("$")
                   \|     exe "normal! g`\""
                   \|  endif


"====[ I'm sick of typing :%s/.../.../g ]=======

nmap S  [Shortcut for :s///g]  :%s//g<LEFT><LEFT>
vmap S                         :s//g<LEFT><LEFT>



"====[ Set up smarter search behaviour ]=======================

set incsearch       "Lookahead as search pattern is specified
set ignorecase      "Ignore case in all searches...
set smartcase       "...unless uppercase letters used

set hlsearch        "Highlight all matches
highlight clear Search
highlight       Search    ctermfg=White

"Delete in normal mode switches off highlighting till next search...
nmap <silent> <BS> :nohlsearch



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
nnoremap <Space> <PageDown>


"=====[ Show help files in a new tab ]==============

"Only apply to .txt files...
augroup HelpInTabs
    autocmd!
    autocmd BufEnter  *.txt   call HelpInNewTab()
augroup END

"Only apply to help files...
function! HelpInNewTab ()
    if &buftype == 'help' && g:help_in_tabs
        "Convert the help window to a tab...
        execute "normal \<C-W>T"
    endif
endfunction



"=====[ Search folding ]=====================

" Toggle on and off...
nmap <silent> <expr>  zz  FS_ToggleFoldAroundSearch({'context':1})

" Show only Perl sub defns...
nmap <silent> <expr>  zp  FS_FoldAroundTarget('^\s*sub\s\+\w\+',{'context':1})

" Show only Perl sub defns and comments...
nmap <silent> <expr>  za  FS_FoldAroundTarget('^\s*\%(sub\s.*\\|#.*\)',{'context':0, 'folds':'invisible'})

" Show only C #includes...
nmap <silent> <expr>  zu  FS_FoldAroundTarget('^\s*use\s\+\S.*;',{'context':1})


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



" HTML stuff from http://www.stripey.com/vim/html.html
autocmd FileType css,html,xhtml,tt2html set smartindent
nnoremap \hc :call InsertCloseTag()<CR>
imap <F8> <Space><BS><Esc>\hca

function! InsertCloseTag()
" inserts the appropriate closing HTML tag; used for the \hc operation defined
" above;
" requires ignorecase to be set, or to type HTML tags in exactly the same case
" that I do;
" doesn't treat <P> as something that needs closing;
" clobbers register z and mark z
" 
" by Smylers  http://www.stripey.com/vim/
" 2000 May 3

  if &filetype == 'html' || &filetype == 'xhtml' || &filetype == 'tt2html'
  
    " list of tags which shouldn't be closed:
    let UnaryTags = ' Area Base Br DD DT HR Img Input LI Link Meta P Param '

    " remember current position:
    normal mz

    " loop backwards looking for tags:
    let Found = 0
    while Found == 0
      " find the previous <, then go forwards one character and grab the first
      " character plus the entire word:
      execute "normal ?\<LT>\<CR>l"
      normal "zyl
      let Tag = expand('<cword>')

      " if this is a closing tag, skip back to its matching opening tag:
      if @z == '/'
        execute "normal ?\<LT>" . Tag . "\<CR>"

      " if this is a unary tag, then position the cursor for the next
      " iteration:
      elseif match(UnaryTags, ' ' . Tag . ' ') > 0
        normal h

      " otherwise this is the tag that needs closing:
      else
        let Found = 1

      endif
    endwhile " not yet found match

    " create the closing tag and insert it:
    let @z = '</' . Tag . '>'
    normal `z"zp

  else " filetype is not HTML
    echohl ErrorMsg
    echo 'The InsertCloseTag() function is only intended to be used in HTML ' .
      \ 'files.'
    sleep
    echohl None
  
  endif " check on filetype

endfunction " InsertCloseTag()

autocmd BufEnter * if &filetype == "html" || &filetype == 'xhtml' || &filetype == 'tt2html' | call MapHTMLKeys() | endif
function! MapHTMLKeys(...)
" sets up various insert mode key mappings suitable for typing HTML, and
" automatically removes them when switching to a non-HTML buffer

  " if no parameter, or a non-zero parameter, set up the mappings:
  if a:0 == 0 || a:1 != 0

    " require two backslashes to get one:
    inoremap \\ \

    " then use backslash followed by various symbols insert HTML characters:
    inoremap \& &amp;
    inoremap \< &lt;
    inoremap \> &gt;
    inoremap \. ·

    " em dash -- have \- always insert an em dash, and also have _ do it if
    " ever typed as a word on its own, but not in the middle of other words:
    inoremap \- &mdash;
    iabbrev _ &mdash;

    " double quotes
    inoremap \[ &ldquo;
    inoremap \] &rdquo;

    " hard space with <Ctrl>+Space, and \<Space> for when that doesn't work:
    inoremap \<Space> &nbsp;
    imap <C-Space> \<Space>

    " have the normal open and close single quote keys producing the character
    " codes that will produce nice curved quotes (and apostophes) on both Unix
    " and Windows:
    inoremap ` &lsquo;
    inoremap ' &rsquo;
    " then provide the original functionality with preceding backslashes:
    inoremap \` `
    inoremap \' '

    " curved double open and closed quotes (2 and " are the same key for me):
    inoremap \2 &#8220;
    inoremap \" &#8221;
    
    " when switching to a non-HTML buffer, automatically undo these mappings:
    autocmd! BufLeave * call MapHTMLKeys(0)

  " parameter of zero, so want to unmap everything:
  else
    iunmap \\
    iunmap \&
    iunmap \<
    iunmap \>
    iunmap \-
    iunabbrev _
    iunmap \<Space>
    iunmap <C-Space>
    iunmap `
    iunmap '
    iunmap \`
    iunmap \'
    iunmap \2
    iunmap \"

    " once done, get rid of the autocmd that called this:
    autocmd! BufLeave *

  endif " test for mapping/unmapping

endfunction " MapHTMLKeys()


set cursorline
