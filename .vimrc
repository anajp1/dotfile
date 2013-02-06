"---------------------------------------------------------------------------
"" OS毎に.vimの読み込み先を変える{{{
"---------------------------------------------------------------------------
if has('win32')
	:let $VIMFILE_DIR = 'vimfiles'
else
	:let $VIMFILE_DIR = '.vim'
endif
"		" ～ こっから先、~/.vimを参照する場合、代わりに、~/.$VIMFILE_DIR
"		と書くこと!
"		"}}}

""gittest
"UTF-8で文字幅表示を２文字分使う
set ambiwidth=double
"タブの左側にカーソル表示（タブや改行を表示しない？）
set nolist
"外部エディタで編集中のファイルが変更されたら自動で読み直す
set autoread
"ハイテク改行 
set smartindent
"set cindent
set cindent
" インクリメントサーチ
set incsearch
set hlsearch
" シフトの移動料
set shiftwidth=4
" tab関係
set smarttab
set tabstop=4
set shiftwidth=4
"set expandtab
" 編集中のタイトルを表示
set title
"括弧入力時の対応する括弧を表示
set showmatch
" バックスペースの挙動
set backspace=indent,eol,start
"swapファイルをまとめておく場所（DropBox対策）
set swapfile
set directory=~/.vimswap
"カーソルがある行、列を表示（only vim）
set ruler
"編集モードのときに画面の下に表示がでる
set showmode
"no backup
set nobackup
"esc押したときime off
"set imdisable
" 挿入モード終了時に IME 状態を保存しない
"inoremap <silent> <Esc> <Esc>
"inoremap <silent> <C-[> <Esc>
"日本語入力固定モード」切り替えキー
"inoremap <silent> <C-j> <C-^>
"help検索順
set helplang=ja,en
"日本語ヘルプフリーズ問題対策
set notagbsearch

"検索時に大文字小文字を区別しない
set ignorecase
"検索altercation / solarized 能登気に大文字が含まれている場合は区別して検索
set smartcase

"最後altercation / solarized まで検索したら先頭に戻る
set wrapscan


"
""command! Gcc call s:Gcc()
""nmap <F6> :Gcc<CR>

""function! s:Gcc()
""	:w
""		:!gcc % -o %.out
""		:!%.out
""		endfunction

"":compiler gcc
""function! s:Gcc()
"":make	:!gcc % -o %.out
""		:!%.out
"		endfunction


"":ab #b /*****
"":ab #e *****/
"":ab #n \n 

noremap <C-p> [[?^?s*$<CR>jz<CR>
noremap <C-n> /^?s*$<CR>]]?^?s*$<CR>jz<CR>

"syntax slf
""let mysyntaxfile = "~/.vim/vimsyntax/sfl.vim"
syntax on

" 文字コードの自動認識 
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック 
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合はfileencodingにencodingを使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif


"入力モード時、ステータスラインのカラーを変更
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END


"全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /　/

"color scheme
hi Function ctermfg=darkgreen
hi Repeat ctermfg=darkgreen
hi String ctermfg=darkmagenta
hi Number ctermfg=darkmagenta
hi Boolean ctermfg=darkmagenta
hi Normal ctermfg=gray ctermbg=black
hi Cursor ctermfg=gray
hi Comment ctermfg=darkcyan
hi Constant term=underline ctermfg=blue
hi Special ctermfg=blue
hi Identifier term=underline ctermfg=white
hi Statement ctermfg=blue
hi PreProc term=underline ctermfg=darkgreen
hi Type term=underline ctermfg=darkgreen
hi Underlined term=underline cterm=underline ctermfg=darkcyan
hi Ignore ctermfg=blue
hi Error term=bold ctermbg=darkmagenta ctermfg=black
hi Todo term=bold ctermfg=black ctermbg=darkcyan
hi Pmenu ctermbg=black ctermfg=gray
hi PmenuSel ctermbg=darkcyan ctermfg=black
hi PmenuSbar ctermbg=darkred
hi PmenuThumb cterm=reverse ctermfg=gray
hi TabLine term=underline cterm=underline ctermfg=gray ctermbg=darkred
hi TabLineSel term=bold
hi TabLineFill term=reverse cterm=reverse
hi MatchParen term=reverse ctermfg=brown ctermbg=darkcyan
hi SpecialKey term=bold ctermfg=gray
hi NonText term=bold ctermfg=blue
hi Directory term=bold ctermfg=brown
hi ErrorMsg ctermbg=darkmagenta ctermfg=black
hi IncSearch term=reverse cterm=reverse ctermfg=brown ctermbg=black
hi Search term=reverse ctermfg=black ctermbg=brown
hi MoreMsg term=bold ctermfg=darkgreen
hi ModeMsg term=bold ctermfg=darkmagenta
hi LineNr term=underline cterm=underline ctermfg=blue ctermbg=black
hi Question term=bold ctermfg=blue
hi StatusLine term=bold,reverse cterm=reverse ctermfg=blue ctermbg=black
hi StatusLineNC term=bold,reverse cterm=reverse ctermfg=blue ctermbg=black
hi VertSplit ctermfg=black ctermbg=darkred term=reverse cterm=reverse
hi Title ctermfg=gray
hi Visual term=reverse cterm=reverse ctermfg=darkcyan ctermbg=black
hi VisualNOS term=bold,underline ctermfg=darkcyan ctermbg=black
hi WarningMsg term=bold ctermfg=darkmagenta
hi WildMenu term=bold ctermfg=black ctermbg=darkcyan
hi Folded ctermbg=darkcyan ctermfg=black
hi FoldColumn ctermbg=darkcyan ctermfg=black
hi DiffAdd term=bold ctermbg=brown ctermfg=black
hi DiffChange term=bold ctermbg=darkred
hi DiffDelete term=bold ctermfg=black ctermbg=brown
hi DiffText term=reverse ctermbg=darkmagenta ctermfg=black
hi SignColumn term=bold ctermfg=black ctermbg=darkcyan

"if, else, else-if, switch, for, while, do-while文の入力補助
function! AutoEndForC()
  let line = strpart(getline('.'), 0, col('.'))
  "if, else, else-if, switch, for, while, do
  let serchWords = [
    \ '^\t*if$',
    \ '^\t*} \=else$',
    \ '^\t*} \=else if$',
    \ '^\t*switch$',
    \ '^\t*for$',
    \ '^\t*while$',
    \ '^\t*do$'
    \ ]
  let endsStatements = [
    \ "\ (  ) {\n}\<Esc>0b4\<LEFT>a",
    \ "\ {\n}\<Esc>0b",
    \ "\ (  ) {\n}\<Esc>0b4\<LEFT>a",
    \ "\ (  ) {\n}\<Esc>0b4\<LEFT>a",
    \ "\ (  ) {\n}\<Esc>0b4\<LEFT>a",
    \ "\ (  ) {\n}\<Esc>0b4\<LEFT>a",
    \ "\ {\n} while(  );\<Esc>3\<LEFT>a"
    \]
  let i = 0
  for regexp in serchWords
    if line =~ regexp
      return endsStatements[i]
    endif
    let i = i + 1
  endfor
  return "NF"
endfunction

"セミコロンが押されたとき一緒に改行する。
function! AutoSemicolonEnterForC()
  let line = strpart(getline('.'), 0, col('.') - 1)
  if line =~ '^\t*for \=('
    "for文を記述中
    return ";"
  else
    let words = [
      \ "cString",
      \ "cCppString",
      \ "cCharacter",
      \ "cComment",
      \ "cCommentStart",
      \ "cCommentL",
      \ "javaString",
      \ "javaCharacter",
      \ "javaComment",
      \ "javaLineComment",
      \ "javaScriptStringD",
      \ "javaScriptStringS",
      \ "javaScriptComment",
      \ "javaScriptLineComment"
      \ ]
    let s = synIDattr(synID(line("."),col("."),0),"name")
    for word in words
      if s == word
        return ";"
      endif
    endfor
    return ";\<CR>"
  endif
endfunction

function! GetSemicolonForC()
  "自動的に(){}を付与する
  let result = AutoEndForC()
  if result == "NF"
    ";+改行 or ;
    return AutoSemicolonEnterForC()
  endif
  return result
endfunction

"au FileType c,cpp,java,javascript inoremap <expr> ; GetSemicolonForC()

"カーソル位置の復元
autocmd BufReadPost *
	\ if line("'\"") > 1 && line("'\"") <= line("$") |
	\   exe "normal! g`\"" |
	\ endif

"ステータスラインに文字コードと改行文字を表示する（ウインドウ幅によって表示項目を調整）
if winwidth(0) >= 120
    set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %(%{GitBranch()}\ %)\ %F%=[%{GetB()}]\ %l,%c%V%8P
else
    set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %(%{GitBranch()}\ %)\ %F%=[%{GetB()}]\ %l,%c%V%8P
endif


"ESC２回押しでハイライト消去
nmap <Esc><Esc> :nohlsearch<CR>

" 検索語が画面の真ん中に来るようにする
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" qq で上書き保存して終了 Shift + zz
nmap qq :wq<CR>


"""plugin関係
""neobundle
filetype off
if has('vim_starting')
	set runtimepath+=~/$VIMFILE_DIR/neobundle.vim.git
	call neobundle#rc(expand('~/.vim/.bundle'))
endif

NeoBundle 'Shougo/unite.vim'
"NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/vimproc'
NeoBundle 'thinca/vim-fontzoom'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'molokai'
"NeoBundle 'oceandeep'
NeoBundle 'a.vim'
NeoBundle 'vim-jp/vimdoc-ja'

filetype plugin indent on 

""vim-indent-guides
""expandtabを有効にしないと使えないため使ってない
"colorscheme tir_black
"set ts=4 sw=4 et
"hi IndentGuidesOdd ctermbg=black
"hi IndentGuidesEven ctermbg=darkgrey
" vim立ち上げたときに、自動的にvim-indent-guidesをオンにする
"let g:indent_guides_enable_on_vim_startup=1
"set ts=2 sw=2 et
" " ガイドをスタートするインデントの量
let g:indent_guides_start_level=2
" " 自動カラーを無効にする
let g:indent_guides_auto_colors=0
" " 奇数インデントのカラー
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#262626
hi IndentGuidesOdd ctermbg=gray
" " 偶数インデントのカラー
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#3c3c3c
hi IndentGuidesEven ctermbg=darkgray
" " ハイライト色の変化の幅
let g:indent_guides_color_change_percent = 30
" " ガイドの幅
let g:indent_guides_guide_size = 1

""vimproc
if has('mac')
	let g:vimproc_dll_path = $VIMRUNTIME . '/autoload/vimproc_mac.so'
elseif has('win32')
	let g:vimproc_dll_path = $HOME . '.vim/bundle/vimproc/autoload/vimproc_win32.dll'
elseif has('win64')
	let g:vimproc_dll_path = $HOME . '.vim/bundle/vimproc/autoload/vimproc_win64.dll'
endif

""vim-quickrun
let g:quickrun_config = {}
let g:quickrun_config._ = {'runner' : 'vimproc'}
"set splitbelow "新しいウィンドウを下に開く



"colorscheme desert


""windows
highlight zenkakuda cterm=underline ctermfg=black guibg=black
if has('win32') && !has('gui_running')
		" win32のコンソールvimはsjisで設定ファイルを読むので、
		" sjisの全角スペースの文字コードを指定してやる
 		match zenkakuda /\%u8140/
else
 			match zenkakuda /　/ "←全角スペース
endif



