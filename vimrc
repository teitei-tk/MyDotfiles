" ----------------------------------------------------------------------- "
" NeoBundle
" ----------------------------------------------------------------------- "
set nocompatible " be iMproved
filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#rc(expand('~/.vim/bundle/'))


" required!
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle "Shougo/neocomplcache.git"
NeoBundle 'Shougo/vimproc'

" buffer tab
NeoBundle "fholgado/minibufexpl.vim.git"

" status bar
NeoBundle "bling/vim-airline.git"
NeoBundle 'alpaca-tc/alpaca_powertabline'
NeoBundle 'Lokaltog/powerline', { 'rtp' : 'powerline/bindings/vim'}

" colorscheme
NeoBundle 'railscasts'
NeoBundle 'Zenburn'

" original repos on github
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'pekepeke/titanium-vim'
NeoBundle "scrooloose/syntastic.git"
NeoBundle 'tpope/vim-fugitive.git'
NeoBundle 'basyura/jslint.vim'


" python
NeoBundle "nathanaelkane/vim-indent-guides"
NeoBundle "Glench/Vim-Jinja2-Syntax.git"

" vim-scripts repos
NeoBundle 'L9'
NeoBundle 'FuzzyFinder'
NeoBundle 'Align'
NeoBundle 'AutoClose'
NeoBundle 'The-NERD-tree'
NeoBundle 'majutsushi/tagbar'

" non github repos
NeoBundle 'git://git.wincent.com/command-t.git'

" required!
filetype plugin indent on 
filetype indent on
syntax on

" ----------------------------------------------------------------------- "
" Setting
" ----------------------------------------------------------------------- "
set nu
set expandtab
set shiftwidth=4
set showmatch
set smarttab
set tabstop=4
set cursorline
set cursorcolumn
set nocompatible " be iMproved

" swapfile
set swapfile
set directory=~/.vim/backup

" backup
set backup
set backupdir=~/.vim/backup

" Setting For Python
autocmd FileType python setl nocindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4

" jslint.vim
function! s:javascript_filetype_settings()
    autocmd BufLeave <buffer> call jslint#clear()
    autocmd BufWritePost <buffer> call jslint#check()
    autocmd CursorMoved <buffer> call jslint#message()
endfunction
autocmd FileType javascript call s:javascript_filetype_settings()

" phpLint"
augroup PHP
    autocmd!
    autocmd FileType php set makeprg=php\ -l\ %
    autocmd FileType php :set dictionary=~/.vim/php.dict
    " php -lの構文チェックでエラーがなければ「No syntax errors」の一行だけ出力される
    autocmd BufWritePost *.php silent make | if len(getqflist()) != 1 | copen | else | cclose | endif
augroup END

" Jinja2
au BufNewFile,BufRead *.jinja2,*.jinja setf jinja


" ------------------------------------------------------------------------ "
" minibufexpl
" ------------------------------------------------------------------------ "
let g:miniBufExplMapWindowNavVim=1 "hjklで移動
let g:miniBufExplSplitBelow=0 " Put new window above
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplSplitToEdge=1

nnoremap <C-d> : bd<CR> " バッファを閉じる
nmap <Space> : MBEbn<CR> " 次のバッファ
nmap <C-n> : MBEbn<CR> " 次のバッファ
nmap <C-p> : MBEbp<CR> " 前のバッファ


" ------------------------------------------------------------------------ "
" neocomplcache
" ------------------------------------------------------------------------ "
let g:neocomplcache_enable_at_startup = 1 "起動時に有効化
function InsertTabWrapper()
    if pumvisible()
        return "\<c-n>"
    endif
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k\|<\|/'
        return "\<tab>"
    elseif exists('&omnifunc') && &omnifunc == ''
        return "\<c-n>"
    else
        return "\<c-x>\<c-o>"
    endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" 補完ウィンドウの設定
set completeopt=menuone

" 起動時に有効化
let g:neocomplcache_enable_at_startup = 1

" autocmpltepopを無効化
lef g:g:acp_enableAtStartup = 0

" 大文字が入力されるまで大文字小文字の区別を無視する
let g:neocomplcache_enable_smart_case = 1

" _(アンダースコア)区切りの補完を有効化
let g:neocomplcache_enable_underbar_completion = 1

let g:neocomplcache_enable_camel_case_completion = 1

" ポップアップメニューで表示される候補の数
let g:neocomplcache_max_list = 20

" シンタックスをキャッシュするときの最小文字長
let g:neocomplcache_min_syntax_length = 3

" ディクショナリ定義
let g:neocomplcache_dictionary_filetype_lists = {
\ 'default' : '',
\ 'php' : $HOME . '/.vim/dict/php.dict',
\ 'ctp' : $HOME . '/.vim/dict/php.dict'
\ }

if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
    let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" スニペットを展開する。スニペットが関係しないところでは行末まで削除
imap <expr><C-k> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-o>D"
smap <expr><C-k> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-o>D"

" 前回行われた補完をキャンセルします
inoremap <expr><C-g> neocomplcache#undo_completion()

" 補完候補のなかから、共通する部分を補完します
inoremap <expr><C-l> neocomplcache#complete_common_string()

" 改行で補完ウィンドウを閉じる
inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"

"tabで補完候補の選択を行う
inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"

" <C-h>や<BS>を押したときに確実にポップアップを削除します
inoremap <expr><C-h> neocomplcache#smart_close_popup().”\<C-h>”

" 現在選択している候補を確定します
inoremap <expr><C-y> neocomplcache#close_popup()

" 現在選択している候補をキャンセルし、ポップアップを閉じます
inoremap <expr><C-e> neocomplcache#cancel_popup()

" snipetの配置場所
let g:neocomplcache_snippets_dir='~/.vim/snippets'
imap <C-k> <plug>(neocomplcache_snippets_expand)
smap <C-k> <plug>(neocomplcache_snippets_expand)


"------------------------------------------------------------------------"
" colorscheme
" ------------------------------------------------------------------------ "
""let scheme = 'zenburn'
let scheme = 'railscasts'
augroup guicolorscheme
    autocmd!
    execute 'autocmd GUIEnter * colorscheme' scheme
augroup END
execute 'colorscheme' scheme
let g:netrw_liststyle = 3
let g:netrw_altv = 1

" neocomplcache保管時のback-ground-color
hi Pmenu ctermbg=8

" neocomplcacheの現在選択時 
hi PmenuSel ctermbg=1

"------------------------------------------------------------------------"
" status Line
" ------------------------------------------------------------------------ "
function! g:Date()
    return strftime("%x %H:%M")
endfunction

" gitのbranch名をstatusバーに表示
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" vim立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup=1
" " ガイドをスタートするインデントの量
let g:indent_guides_start_level=2
" " 自動カラーを無効にする
let g:indent_guides_auto_colors=0
" " 奇数インデントのカラー
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#262626 ctermbg=gray
" " 偶数インデントのカラー
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#3c3c3c ctermbg=darkgray
" " ハイライト色の変化の幅
let g:indent_guides_color_change_percent = 30
" " ガイドの幅
let g:indent_guides_guide_size = 1"


"------------------------------------------------------------------------"
" vim airline & powerline
" ------------------------------------------------------------------------ "
set laststatus=2
set rtp+=~/.vim/vundle/powerline/powerline/bindings/vim

" powerline fontを使用
let g:airline_powerline_fonts = 1  " 