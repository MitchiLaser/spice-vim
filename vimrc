" Spice-Vim 🌶️

" Boost your productivity with this Vim quick starter


" disable automatic visual selection when highlighting text with the mouse
" cursor. Start with a clean Vim environment
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" disable vi compatibility "
set nocompatible

set mouse-=a	" disable all mouse-based features

" activate numbers and relative numbers
" with both being set: numbers are shown absolutely on the line where the
" cursor is and relatively from that line on
set nu rnu

" highlight the line where the cursor is
set cursorline

" enable file type based detection and execution of specified startup scripts
filetype plugin on

" enable automatic indentation
filetype indent on
filetype plugin indent on
" set autoindent	" optionally this also works

" activate autoreload
set ar

" activate smarttab
set sta

" set utf-8 as default encoding
set encoding=utf-8

" required by vim-which-key
set timeout

" enable code folding
set foldmethod=indent
set foldlevel=99

" Use space as leader key
" Leader key is a namespace for custom defined keybindings
let mapleader="\<Space>"
let localleader="\\"

" Remap :W to :w
" this avoids 'Not an editor command' error when shift is accidentally pressed
command W w
" optionally this would remap all existing ex commands which start with a w
" and replace them with a uppercase variant
" The Exclamation mark (!) will replace all existing vim commands
"command! -bang -range=% -complete=file -nargs=* W <line1>,<line2>write<bang> <args>
" this can also be done for :Q
"command! -bang Q quit<bang>

" save as sudo
ca w!! w !sudo tee "%"

" ex command to reload ~/.vimrc
command Reload so ~/.vimrc

" open help (:h) in new tab
cabbrev help tab help
cabbrev h tab help

" some spelling options
set spell
set spelllang=de_de,en_gb,en_us
" automatically correct the previous spelling mistake from the cursor position
" By pressing CTRL+L in insert mode the previous spelling mistake (backwards
" from the cursor position) will be searched and replaced with the first
" suggestion. After that the cursor will be put back to its previous position.
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" When marking text in a visual selection:
" Press C-r to replace the text and then iterate over all occurrences
" and pres y / n to replace / keep them
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" clear empty spaces at the end of lines on save of python files
autocmd BufWritePre *.py :%s/\s\+$//e

" fix problems with uncommon shells (fish, xonsh) and plugins running commands
" (neomake, ...)
set shell=/bin/bash

" set python3 as default
" nuke python2, nobody needs python2 any more
set pyxversion=3

" better backup, swap and undos storage for vim
set directory=~/.vim/dirs/tmp     " directory to place swap files in
set backup                        " make backup files
set backupdir=~/.vim/dirs/backups " where to put backup files
set undofile                      " persistent undos - undo after you re-open the file
set undodir=~/.vim/dirs/undos
set viminfo+=n~/.vim/dirs/viminfo
" create needed directories if they don't exist
if !isdirectory(&backupdir)
	call mkdir(&backupdir, "p")
endif
	if !isdirectory(&directory)
	call mkdir(&directory, "p")
endif
	if !isdirectory(&undodir)
	call mkdir(&undodir, "p")
endif


"Install and Start all the Plugins with Vim-Plug
call plug#begin()

" fancy icons for all the plugins
Plug 'ryanoasis/vim-devicons'

" NerdTREE Filesystem browser
Plug 'preservim/nerdtree' |
	\ Plug 'Xuyuanp/nerdtree-git-plugin'

" use shortcut CTRL + N in normal mode to toggle NERDTree file explorer
nmap <C-n> :NERDTreeToggle<CR>
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Limelight » highlight indentation at cursor position
Plug 'junegunn/limelight.vim'
let g:limelight_default_coefficient = 0.7
let g:limelight_paragraph_span = 1
let g:limelight_priority = -1
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
" Toggle Limelight on <Leader>l
nmap <Leader>l :Limelight!!<CR>

" nord-vim colour scheme
"Plug 'arcticicestudio/nord-vim'
" fork of nord-vim which has no problems in displaying visual selection
Plug 'MitchiLaser/fork-nord-vim'

" monokai color theme
Plug 'crusoexia/vim-monokai'

" lighthouse theme for vim
Plug 'lighthaus-theme/vim-lighthaus'

" automatically close HTML tags
Plug 'alvan/vim-closetag'

" Automatically close parenthesis, etc
Plug 'Townk/vim-autoclose'
" Fix to let ESC work as expected with Autoclose plugin
" (without this, when showing an autocompletion window, ESC won't leave insert
"  mode)
let g:AutoClosePumvisible = {"ENTER": "\<C-Y>", "ESC": "\<ESC>"}

" automatic indentation in python scripts
Plug 'vim-scripts/indentpython.vim'

" Tagbar: source code outline which can be used to jump to tags
Plug 'preservim/tagbar'
" Use F8 Key to toggle Tagbar
nmap <F8> :TagbarToggle<CR>
" use gutentags for automatic tag generation
Plug 'ludovicchabant/vim-gutentags'

" table mode: automatically draw spaces in markdown tables to keep everything
" aligned. This also works for ASCII art tables
Plug 'dhruvasagar/vim-table-mode'
autocmd VimEnter * silent! :TableModeEnable

" Markdown Preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" Do not start automatically
let g:mkdp_auto_start = 0
" key-bindings:
nmap <Leader>mp :MarkdownPreview<CR>
nmap <Leader>mps :MarkdownPreviewStop<CR>
nmap <Leader>mpt :MarkdownPreviewToggle<CR>

" status bar at the lower end of the vim window
Plug 'vim-airline/vim-airline'
set laststatus=2
" some airline configuration to make it look more fancy
" this was partially disabled after an official theme was installed on top of
" this layout
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#branch#enabled=1
"let g:airline#extensions#ale#enabled = 1	" apparently this works without
"being activated manually
let g:airline#extensions#tabline#show_buffers = 0
" official repository for airline themes
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='lighthaus'

" Create python docstring templates by calling :Docstring or :DocstringTypes
" Docstring style is current set to numpy (see documentation)
Plug 'pixelneo/vim-python-docstring'
let g:python_style = 'numpy'

" LaTeX Support for VIM
Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

" Vimtex has its own ToC, additional to the one from Tagbar
nmap <leader>vt :VimtexTocToggle<CR>

" live preview in evince (or other pdf viewer)
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
let g:livepreview_previewer = 'evince'
let g:livepreview_use_biber = 1

" Vimux: better interaction with tmux
Plug 'preservim/vimux'
" In a Tmux Session: Call :VimuxRunCommand {command} to open a whell window (in Tmux)
" where the command will be run. Optionally VimuxRunLastCommand will repeat
" the last call

" NERD Commenter
Plug 'preservim/nerdcommenter'
" use <Leader> + cc / cs / cu ... to manage comments

" indexed search: print number of search results
" It shows how many search results are in the buffer
Plug 'henrik/vim-indexed-search'

" C++ Syntax Highlighting
Plug 'bfrg/vim-cpp-modern'

" Syntax Highlighting for OpenSCAD
Plug 'sirtaj/vim-openscad'

" Language Support for Rust
Plug 'rust-lang/rust.vim'

" a huge collection of language packs
Plug 'sheerun/vim-polyglot'

" general purpose fuzzy finder
" It can be used to find files in the current working directors
" Use :FZF {?dir?} or key bindings (see below) to call it
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
nnoremap <Leader>f :FZF<CR>
nnoremap <Leader>b :Buffers<CR>
" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" Search for Todo-Comments, Fixme-Comments or other suspicious things and display them in a handy list
" call <Leadaer>t to open the tasklist
Plug 'fisadev/FixedTaskList.vim'

" Deoplete (asynchronous autocompletion) and dependencies
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
let g:deoplete#enable_at_startup = 1
" line below commented out because it throws an error
"call deoplete#custom#option({'ignore_case': v:true,'smart_case': v:true,})
" start deoplete in multithreaded mode (tried this as a fox for
" deoplete-ternjs error messages popping up)
"autocmd BufEnter call deoplete#custom#option('num_processes', 4)
" complete with words from any opened file
let g:context_filetype#same_filetypes = {}
let g:context_filetype#same_filetypes._ = '_'
" specify the right python interpreter
let g:python3_host_prog = 'python3'
" Asynchronous linting engine
Plug 'dense-analysis/ale'
" use ale for autocompletion with deoplete in combination
let g:ale_completion_enabled = 1
" ale configuration
let g:ale_completion_enabled = 0
let g:ale_linters_explicit = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1
let g:ale_virtualtext_cursor = 1
let g:ale_linters = {
	\'python': ['pylint', 'flake8', 'pylsp'],
	\'rust': ['rust-analyzer', 'cargo'],
	\'java': ['checkstyle'],
	\ 'javascript': ['eslint'],
	\'cpp': ['clangd', 'clangtidy'],
	\'tex': ['texlab'],
	\'vhdl': ['hdl-checker']
\}
let g:ale_c_parse_compile_commands = 1
let g:ale_fixers = {
	\ '*': ['remove_trailing_lines', 'trim_whitespace'],
	\	'cpp': ['clang-format'],
	\	'python': ['autopep8'],
	\ 'javascript': ['eslint'],
\}
" options for python linters and fixers
let g:ale_python_pylint_options = "--errors-only --disable=C,R --max-line-length=150"
let g:ale_python_flake8_options = "--ignore=E501"
let g:ale_python_autopep8_options = "--max-line-length 150"
"TODO: replace the following line with proper C++ handling
autocmd BufEnter call ale#Set('c_clangformat_options', 'GNU')
nmap <Leader>gd :ALEGoToDefinition<CR>
nmap <Leader>gr :ALEFindReferences<CR>
nmap <Leader>K :ALEHover<CR>
let g:ale_set_balloons=1
nmap <F10> :ALEFix<CR>


" Completion for languages within other opened files
" p.Ex. A JavaScript code inside an HTML tag
Plug 'Shougo/context_filetype.vim'

" Python autocompletion
Plug 'davidhalter/jedi-vim'
" Disable autocompletion (using deoplete instead)
let g:jedi#completions_enabled = 0
"commented out because I wanted to remap the key bindings to the Leader key
"(TODO)
"  All these mappings work only for python code:
" " Go to definition
" let g:jedi#goto_command = ',d'
" " Find ocurrences
" let g:jedi#usages_command = ',o'
" " Find assignments
" let g:jedi#goto_assignments_command = ',a'
" " Go to definition in new tab
" nmap ,D :tab split<CR>:call jedi#goto()<CR>

" Python autocompletion for deoplete
Plug 'deoplete-plugins/deoplete-jedi'
let g:deoplete#sources#jedi#show_docstring = 1

" TODO: currently deoplete-ternjs is not working correctly!
" JavaScript Autocomplete
Plug 'ternjs/tern_for_vim', { 'do' : 'npm install' }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install tern' }
" Use tern_for_vim tern server
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]
"autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

" All about surroundings except surround sound
Plug 'tpope/vim-surround'
" you can use `ds"` to delete surrounding Parenthese,
" use `cs"'` to replace " with '
" use `yss)` to surround whole line with ( )
" Using open brackets in the command also adds a space in between
" with `ysiw<p>` a word will be put into an html tag

" being able to repeat plugin calls with the dot command
Plug 'tpope/vim-repeat'

" select indentations (inside / around)
" dunno if i will ever use this
Plug 'michaeljsmith/vim-indent-object'
" Commands:
" <count>ai: select An Indentation level and line above
" <count>ii / iI: select Inside Indentation level (no live above)
" <count>aI: select An Indentation level and lines above / below

" indent-based motion
Plug 'jeetsukumaran/vim-indentwise'
" I don't know how to use this, have not read the documentation completely

" Highlight matching html tags
Plug 'valloric/MatchTagAlways'

" Git integration
Plug 'tpope/vim-fugitive'

" Git/mercurial/others diff icons on the side of the file lines
Plug 'mhinz/vim-signify'

" Ultisnip: snippet engine
Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger="<s-tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<s-tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-tab>"
" ultisnips can split the window to edit the snippets
let g:UltiSnipsEditSplit="tabdo"

" a collection of defined snippets for the ultisnip engine
Plug 'honza/vim-snippets'

" indentation alignment lines
" TODO: fix problem with language specific indentation, also tagbar should be
" excluded from this plugin
"Plug 'Yggdroot/indentLine'
"let g:indentLine_char = '|'
"let g:markdown_syntax_conceal=0
"let g:vim_json_conceal=0

" asynchronously run makefiles
" Currently disabled because it is not needed and unconfigured
" Plug 'neomake/neomake'

" show available key bindings
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
set timeoutlen=300

" Vim based debugger
Plug 'puremourning/vimspector'
"let g:vimspector_enable_mappings = 'HUMAN'
" HUMAN mappings interfere with some other functions
" therefore this is my own mapping with a prefixed leader key
nmap <Leader><F5>         <Plug>VimspectorContinue
nmap <leader><C-F5> <Plug>VimspectorLaunch
nmap <Leader><F3>         <Plug>VimspectorStop
nmap <Leader><F4>         <Plug>VimspectorRestart
nmap <Leader><F6>         <Plug>VimspectorPause
nmap <Leader><F9>         <Plug>VimspectorToggleBreakpoint
nmap <Leader><F9> <Plug>VimspectorToggleConditionalBreakpoint
nmap <Leader><F8>         <Plug>VimspectorAddFunctionBreakpoint
nmap <Leader><C-F8> <Plug>VimspectorRunToCursor
nmap <Leader><F10>        <Plug>VimspectorStepOver
nmap <Leader><F11>        <Plug>VimspectorStepInto
nmap <Leader><F12>        <Plug>VimspectorStepOut
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools', 'tclpro', 'vscode-bash-debug', 'vscode-js-debug' ]
" default debug configuration for python
Plug 'sagi-z/vimspectorpy', { 'do': { -> vimspectorpy#update() } }

" GitHub Copilot
Plug 'github/copilot.vim'
" Copilot keybindings
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
imap <C-H> <Plug>(copilot-accept-word)
imap <C-K> <Plug>(copilot-accept-line)

" wordy: a plugin to improve the writing style
" call :wordy <jargon> to search for words which are not recommended in the
" document. Turn it off with :wordy off. Jump to the next / previous word with
" :NextWordy and :PrevWordy.
Plug 'preservim/vim-wordy'


" These plugins can be useful but they are neither installed nor configured
" currently
"Plug 'preservim/vim-pencil'
"Plug 'preservim/vim-lexical'

call plug#end()

" previously unused lighthaus theme, currently unused
" colorscheme lighthaus
"silent! colorscheme monokai
silent! colorscheme nord
"set termguicolors
set background=dark

" execute python code (from visual selection)
vnoremap <f5> :!python<CR>
noremap <F5> <ESC>:w<CR>:silent execute "!python %"<CR><CR>
