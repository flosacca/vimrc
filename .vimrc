" vimrc

" General -------------------- {{{

se nocp
se bs=2
se noswf
se ffs=unix,dos
se enc=utf-8
se fencs=ucs-bom,utf-8,cp932,gb18030,latin1

se rtp^=~/.vim
se rtp+=~/.vim/after
se vi+=n~/.viminfo

" Wait forever for mappings
se noto

" Wait 1ms for key codes
" Ideally waiting 0ms is just OK, but there is a problem where vim
" occasionally receives uninterpreted key codes when launched from wsltty
se ttimeout
se ttm=1

se kp=
se nosol

se mmp=2000000

let s:win = has('win32') || has('win64')
let s:gui = has('gui_running')
let s:win_gui = s:win && s:gui
let s:vim8 = v:version >= 800

aug detect_stdin
  au!
  au StdinReadPost * let b:stdin = 1
  au BufWrite * unl! b:stdin
aug END

" ---------------------------- }}}

" Global Mappings ------------ {{{

" Unmapping {{{
sil! vu <C-x>
nn <C-q> <Nop>
nn <Space> <Nop>
" }}}

" Basic keys {{{
nn <expr> : TryFakeCmdLine()

nn U <C-r>

aug local_map
  au!
  " It would have been enough with BufWinEnter, but NERDTree overrides the
  " mapping anyway in some cases, so we override it back in FileType.
  au BufWinEnter,FileType * no <buffer> <silent> q :call Quit()<CR>
aug END

no <silent> Q :call QuitAll()<CR>
no <Space>q q

nn <silent> <Space>w :up<CR>

no <Space>v V

vn x "_d
vn <silent> p :<C-u>call VPut()<CR>
vn P p
vn gp "0p

nn gg gg0
nn G G0
" }}}

" Moving {{{
no <Space>h gT
no <Space>l gt

no <Space>j <C-d>
no <Space>k <C-u>
no <Space>u <C-f>
no <Space>i <C-b>
no <silent> <Space>f :<C-u>call ViewingMode()<CR>

no <C-h> <C-w>h
no <C-j> <C-w>j
no <C-k> <C-w>k
no <C-l> <C-w>l
" }}}

" Search & Replace {{{
nn <silent> & :&&<CR>

nn gs :%s//g<Left><Left>
nn g* :%s/\<<C-r><C-w>\>//g<Left><Left>
no g/ /^\s*\zs

" vn <silent> s :call VSub('g')<CR>
vn s :s//g<Left><Left>

nn <silent> n :call CenterAfter('n')<CR>:call ShowSearch('n')<CR>
nn <silent> N :call CenterAfter('N')<CR>:call ShowSearch('N')<CR>
nn <Space>n n
nn <Space>N N
" }}}

" Text objects {{{
func! TextObjMap(lhs, rhs)
  exe printf('vm a%s a%s', a:lhs, a:rhs)
  exe printf('om a%s a%s', a:lhs, a:rhs)
  exe printf('vm i%s i%s', a:lhs, a:rhs)
  exe printf('om i%s i%s', a:lhs, a:rhs)
endf

call TextObjMap('r', ']')
call TextObjMap('a', '>')
call TextObjMap('v', '}')

nn <silent> co :sil call ExpandTextObj()<CR>
nn <silent> cd :sil call CollapseTextObj()<CR>

nn <silent> csfv :sil call ChangeSurround('f', ['{', '}'])<CR>
nn <silent> csvf :sil call ChangeSurround('v', ['do', 'end'])<CR>
" }}}

" Utils {{{
nn ga <C-a>
vn ga g<C-a>
nn gx <C-x>
vn gx g<C-x>
nn <C-a> ga

nn <silent> <Space>r :redraw!<CR>
nn <silent> <Space>p :let &paste=!&paste<CR>
nn <silent> <Space>. :so ~/.vimrc<CR>

ino <C-\><CR> <End><CR>
ino <C-\><BS> <Up><End><CR>
ino <C-\>e <CR><Up><End><CR>

" If <Esc> is used instead, the cursor will flash noticeably in gVim
ino <silent> <C-k> <C-\><C-o>:call MakeUpper()<CR>

cno ` <C-r>
cno `` `

vn <LeftMouse> "+ygV
vn <RightMouse> "+:<C-u>call VPut()<CR>
nn <silent> <Space>y :call ClipAll()<CR>
vn <silent> gy :call ClipVisual()<CR>

nn <Space>; A;<Esc>

nn <silent> gK :call SeamlessJoin()<CR>

no <M-x> :
cno <M-j> <Down>
cno <M-k> <Up>
" }}}

" ---------------------------- }}}

" Plugins -------------------- {{{

let s:plug_path = expand('~/.vim/autoload/plug.vim')

func! GetPlug()
  if s:win
    return
  end
  let url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  sil exe printf('!curl --create-dirs -sLo %s %s', s:plug_path, url)
  redraw!
  return v:shell_error == 0
endf

com! -bar GetPlug call GetPlug()

let g:has_plug = filereadable(s:plug_path)

if g:has_plug
  sil! call plug#begin('~/.vim/plugged')
else
  com! -bar -nargs=* Plug
end

" Basic --------------------------
" Plug 'flazz/vim-colorschemes'
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
" --------------------------------

" Syntax -------------------------
" Plug 'sheerun/vim-polyglot'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-python/python-syntax'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'rust-lang/rust.vim'
Plug 'udalov/kotlin-vim'
Plug 'gabrielelana/vim-markdown'
Plug 'vim-language-dept/css-syntax.vim'
Plug 'kevinoid/vim-jsonc'
Plug 'cespare/vim-toml'
Plug 'leafOfTree/vim-vue-plugin', { 'tag': 'v1.0.20200714' }
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'rhysd/vim-llvm'
Plug 'dylon/vim-antlr'
Plug 'flosacca/nginx.vim'
Plug 'isobit/vim-caddyfile'
Plug 'ekalinin/Dockerfile.vim'
Plug 'gko/vim-coloresque'
" --------------------------------

" Operation ----------------------
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/tComment'
Plug 'godlygeek/tabular'
" Plug 'terryma/vim-multiple-cursors'
if s:vim8
  Plug 'mg979/vim-visual-multi'
end
Plug 'tpope/vim-abolish'
Plug 'danro/rename.vim'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-rails'
" --------------------------------

" External -----------------------
Plug 'iamcco/markdown-preview.nvim'
" --------------------------------

Plug 'kana/vim-altr'
" Plug 'kana/vim-submode'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-syntax'

if g:has_plug
  call plug#end()
end

ru! macros/matchit.vim

" EasyMotion {{{
let g:EasyMotion_keys = 'asdfghwertyuiopcvbnmlkj'

map gj <Plug>(easymotion-j)
map gk <Plug>(easymotion-k)
nm go <Plug>(easymotion-overwin-line)

map gb <Plug>(easymotion-b)
map gw <Plug>(easymotion-w)
map gB <Plug>(easymotion-ge)
map gW <Plug>(easymotion-e)

let g:EasyMotion_re_line_anywhere = '.'
map gh <Plug>(easymotion-bl)
map gl <Plug>(easymotion-wl)
map gH <Plug>(easymotion-linebackward)
map gL <Plug>(easymotion-lineforward)
" }}}

" NERDTree {{{
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'

let g:NERDTreeMapHelp = 'K'
let g:NERDTreeMapQuit = '<Space>q'

nn <silent> <Space>t :NERDTreeToggle<CR>

" This doesn't work when editing a new dir
let g:NERDTreeChDirMode = 2
" }}}

" Emmet {{{
" im <C-u> <Plug>(emmet-expand-abbr)
" nm <C-u> <Plug>(emmet-expand-abbr)
" vm <C-u> <Plug>(emmet-expand-abbr)

nn <C-t> <C-y>
ino <C-t> <C-y>
" }}}

" Text objects {{{
call TextObjMap('j', 'y')

let g:surround_118 = "{\r}" " v
let g:surround_109 = "$\r$" " m
let g:surround_100 = "$$ \r $$" " d

" Needed only when using noremaps in surround
" nm dsv ds}
" nm csv cs}
" nm dsm ds$
" nm csm cs$

" if exists('*textobj#user#plugin')
"   This does not work
" end
sil! call textobj#user#plugin('latex', {
\   'environment': {
\     'pattern': ['\\begin{[^}]\+}\(\[[^]]*\]\)\?\({[^}]*}\)*\n\?', '\\end{[^}]\+}'],
\     'select-a': 'ae',
\     'select-i': 'ie',
\   },
\  'math-a': {
\     'pattern': '\$\_[^$]*\$',
\     'select': ['a$', 'am'],
\   },
\  'math-i': {
\     'pattern': '\v\$[ \t\r\n]*\zs[^$ \t\r\n]+([ \t\r\n]+[^$ \t\r\n]+)*\ze[ \t\r\n]*\$',
\     'select': ['i$', 'im'],
\   },
\  'displaymath-a': {
\     'pattern': '\$\$\_[^$]*\$\$',
\     'select': 'ad',
\   },
\  'displaymath-i': {
\     'pattern': '\v\$\$[ \t\r\n]*\zs[^$ \t\r\n]+([ \t\r\n]+[^$ \t\r\n]+)*\ze[ \t\r\n]*\$\$',
\     'select': 'id',
\   },
\ })

sil! call textobj#user#plugin('ruby', {
\   'block': {
\     'pattern': ['\<do\>', '\<end\>'],
\     'select-a': 'af',
\     'select-i': 'if',
\   },
\ })
" }}}

" Others {{{
nm gn <Plug>TComment_gcc
vm gn <Plug>TComment_gc

let g:mkdp_auto_close = 0

let g:mkdp_preview_options = { 'disable_sync_scroll': 1 }

let g:markdown_enable_spell_checking = 0

" let g:multi_cursor_select_all_word_key = 'g<C-n>'

" TODO: better mappings
let g:VM_maps = {
\   'Skip Region': '<C-x>',
\   'Remove Region': '<C-d>',
\   'Find Subword Under': '',
\   'Visual Cursors': '<C-n>',
\ }

nm <Space>[ <Plug>(altr-forward)
nm <Space>] <Plug>(altr-back)
" }}}

" ---------------------------- }}}

" View ----------------------- {{{

se nu
se ru
se nowrap
se fdm=marker
se ls=2
se nosmd

aug move_help_window
  au!
  au BufRead * if &bt == 'help' | setl nu | winc L | end
aug END

if !exists('$VIM_CURSOR_BLINK')
  let &t_ti .= "\e[2 q"
  let &t_te .= "\e[4 q"
  let &t_SI .= "\e[6 q"
  let &t_EI .= "\e[2 q"
  if s:vim8
    let &t_SR .= "\e[4 q"
  end
else
  let &t_ti .= "\e[1 q"
  let &t_te .= "\e[3 q"
  let &t_SI .= "\e[5 q"
  let &t_EI .= "\e[1 q"
  if s:vim8
    let &t_SR .= "\e[3 q"
  end
end

func! HasTC()
  if !has('termguicolors')
    return 0
  end
  if !empty($TMUX)
    return system('tmux info') =~# '\v<Tc>[^\n]*<true>'
  end
  return 1
endf

let s:colors = 1
if s:gui
  se go=
  se gfn=mononoki_nf:h13
  aug maximize_gui
    au!
    au GUIEnter * sim ~x
  aug END
elseif $TERM =~# '\v<(256color|direct)>'
  if HasTC()
    let &t_8f = "\e[38;2;%lu;%lu;%lum"
    let &t_8b = "\e[48;2;%lu;%lu;%lum"
    se tgc
  end
else
  unl s:colors
end

try
  unl s:colors
  se bg=dark
  let g:gruvbox_italic = 0
  colo gruvbox
  hi! link Operator GruvboxRed
  let g:lightline = {
\   'colorscheme': 'gruvbox',
\   'mode_map': { 'c': 'NORMAL' }
\ }
catch
  se t_Co=256
  se nocuc
  se nocul
  colo desert
endt

" ---------------------------- }}}

" Format --------------------- {{{

se ts=2
se sw=0
se sts=-1
se et
" se si
se nojs

com! -bar -nargs=1 TS setl ts=<args> | setl sw=0 | setl sts=-1

aug add_file_type
  au!
  au BufRead,FileType * call AddFileType()
aug END

func! AddFileType()
  let ext = expand('%:e')
  if ext ==? 'pgf'
    se ft=tex
  elseif ext ==? 'ipynb'
    se ft=json
  elseif ext ==? 's'
    se ft=ia64
  elseif ext =~? '\v^(asm|inc)$'
    se ft=masm
  end
  if &ft == 'json'
    if s:vim8 && !empty(getcompletion('jsonc', 'filetype'))
      se ft=jsonc
    end
    hi Error NONE
  end
  let base = expand('%:t')
  if base ==# '.gemrc'
    se ft=yaml
  elseif base ==# 'pip.conf'
    se ft=dosini
  end
endf

let g:c_no_curly_error = 1

let g:is_bash = 1
let g:sh_no_error = 1

let g:tex_flavor = 'latex'
let g:tex_no_error = 1

let g:html_indent_script1 = 'zero'

let g:python_highlight_all = 1
let g:python_highlight_space_errors = 0

let g:ruby_indent_assignment_style = 'variable'

let g:go_highlight_trailing_whitespace_error = 0

let g:vim_vue_plugin_use_scss = 1
let g:vim_vue_plugin_highlight_vue_attr = 1
let g:vim_vue_plugin_highlight_vue_keyword = 1

hi link cErrInParen NONE

hi link jsParensError NONE

let s:indent4 = [
\   'make',
\   'c',
\   'cpp',
\   'java',
\   'kotlin',
\   'python',
\   'cuda',
\   'masm',
\   'tex',
\   'nginx',
\   'antlr.*',
\ ]

func! FileTypeConfig()
  setl fo-=ro

  call LSMap('nn', '<F8>', 'Run()', 1)
  call LSMap('nn', '<F9>', ['up', 'call Run()'], 1)

  if &ft =~ printf('\v^(%s)$', join(s:indent4, '|'))
    setl ts=4
  end

  if &ft =~ '\v^(make|caddyfile)$'
    setl noet
  end

  if &ft =~ '\v^(vue)$'
    setl isk+=-
  end

  if &ft =~ '\v^(c|cpp|java)$'
    setl cino=:0,g0,N-s,(s,ws,Ws,j1,J1,m1
  end

  if &ft == 'html'
    setl indk+=0],0)
  end

  if &ft =~ '\v^(python|ruby)$'
    com! -bar NextDef call search('\v^\s*(def|class)>')
    com! -bar PrevDef call search('\v^\s*(def|class)>', 'b')
    call LSMap('no', ']f', 'NextDef', 0, 0)
    call LSMap('no', '[f', 'PrevDef', 0, 0)
  end

  if &ft == 'make'
    call LSMap('nn', '<F7>', ['up', 'call Make()'], 1)
  end

  if &ft =~ '\v^(c|cpp)$'
    call LSMap('nn', '<F5>', 'Debug()', 0)
    call LSMap('nn', '<F6>', 'Compile(["-O2"])', 1)
    call LSMap('nn', '<F7>', 'Compile(["-g3"])', 1)
    call LSMap('nn', '<F9>', ['call Compile(["-g3"])', 'call Run()'], 1)
  end

  if &ft =~ '\v^(java|cuda|masm|tex)$'
    call LSMap('nn', '<F7>', 'Compile()', 1)
    call LSMap('nn', '<F9>', ['call Compile()', 'call Run()'], 1)
  end

  if &ft =~ '^s[ca]ss$'
    call LSMap('nn', '<F7>', 'Compile()', 1)
  end

  if &ft == 'nginx'
    call LSMap('nn', '<Space>s', ['up', 'call system("sudo nginx -s reload")'], 0)
  end

  if &ft == 'sh'
    com! -bar -range Upper <line1>,<line2>s/\v\$\w+>|<\w+\=/\U&/g
  end

  if &ft == 'tex'
    setl inde=
    setl nocul
    setl nocuc
    setl wrap

    ino <buffer> <Tab> \
    ino <buffer> \ <Tab>

    call LSMap('nn', '<F5>', 'InsertTeXEnv()', 0)
    call LSMap('ino', '<F5>', 'InsertTeXEnv()', 0)
  end

  if &ft == 'markdown'
    setl wrap
    call LSMap('nn', '<F8>', 'Run()', 0)
    call LSMap('ino', '<F8>', 'Run()', 0)
  end

  if &ft =~ '^eruby'
    ino <buffer> <C-\>d <%  %><Left><Left><Left>
    ino <buffer> <C-\>f <%=  %><Left><Left><Left>
  end
endf

func! BinReadPost()
  if expand('%:e') != 'txt' && &fenc == 'latin1'
    let b:bin = 1
    se ft=text
    setl fdm=manual
    setl bin
    %!xxd
    setl nobin
  end
endf

func! BinWritePre()
  if get(b:, 'bin', 0)
    let b:cursor_pos = getpos('.')
    %y c
    %s/\v^(\x{8}:)? ?((\x\x)+( (\x\x)+)*)?( *|  .*)$/\2/g
    %!xxd -p -r
    setl bin
  end
endf

func! BinWritePost()
  if get(b:, 'bin', 0)
    setl nobin
    %d _
    put! c
    $d _
    call setpos('.', b:cursor_pos)
  end
endf

aug binary_config
  au!
  au BufRead * sil call BinReadPost()
  au BufWrite * sil call BinWritePre()
  au BufWritePost * sil call BinWritePost()
aug END

func! PureTextConfig()
  if &ft =~ '\v^(text)$' && &bt != 'help'
    setl nocuc
    setl nocul
    setl wrap
    if s:win_gui
      " setl slm=mouse
      if wordcount()['chars'] == 0
        star
      end
    end
  end
endf

aug file_type_config
  au!
  au BufEnter,FileType * call FileTypeConfig()
  au BufRead,BufNewFile * call PureTextConfig()
aug END

func! Chdir(dir)
  let dir = a:dir
  if s:win
    let dir = substitute(dir, '\\', '/', 'g')
  end
  let dir = substitute(dir, '/\?$', '/', '')
  exe 'cd' escape(dir, " \t\n\\")
endf

func! AutoChdir()
  if exists('b:tarfile')
    return
  end
  let dir = expand('%:h')
  if isdirectory(dir)
    call Chdir(dir)
  elseif !empty(dir) && !exists('b:no_dir')
    let b:no_dir = 1
    echoe printf("Directory '%s' does not exist", dir)
  end
endf

func! NerdTreeChdir()
  if !exists('b:NERDTree')
    return
  end
  let path = b:NERDTree.root.path
  if s:win
    let dir = join([path.drive] + path.pathSegments, '\')
  else
    let dir = join([''] + path.pathSegments, '/')
  end
  call Chdir(dir)
endf

aug auto_chdir
  au!
  au BufEnter * call AutoChdir()
  au FileType,BufEnter * call NerdTreeChdir()
aug END

" ---------------------------- }}}

" Functions ------------------ {{{

" Utils ---------------------- {{{
func! Strip(str, ...)
  let pat = get(a:, 1, '\_s*')
  return substitute(a:str, '\v%^' . pat . '(.{-})' . pat . '%$', '\1', '')
endf

func! LStrip(str, ...)
  let pat = get(a:, 1, '\_s*')
  return substitute(a:str, '\v%^' . pat . '(.{-})%$', '\1', '')
endf

func! RStrip(str, ...)
  let pat = get(a:, 1, '\_s*')
  return substitute(a:str, '\v%^(.{-})' . pat . '%$', '\1', '')
endf

func! GetText(lp, rp)
  let pos = getpos('.')
  let reg = @"
  call setpos("'<", a:lp)
  call setpos("'>", a:rp)
  normal! gvy
  let text = @"
  let @" = reg
  call setpos('.', pos)
  return text
endf

func! TryExec(cmd, ...)
  let s:exception = ''
  let pat = get(a:, 1, '.*')
  try
    exe a:cmd
  catch
    if v:exception !~# '^Vim\%((\a\+)\)\?:E' . pat
      echoe v:expcetion
    end
    let s:exception = v:exception
    echoh ErrorMsg
    echom substitute(v:exception, '^Vim\%((\a\+)\)\?:', '', '')
    echoh None
  endt
endf

func! Input(prompt)
  call inputsave()
  let value = input(a:prompt)
  call inputrestore()
  return value
endf

func! MakeUpper()
  let pos = getpos('.')
  let pos[2] -= 1
  call setpos('.', pos)
  normal! gUiw
  let pos[2] += 1
  call setpos('.', pos)
endf

func! Silent(cmd)
  return printf("exe 'normal! :%s<C-v><CR>'", substitute(a:cmd, "'", "''", 'g'))
endf

func! LSMap(map, key, cmd, expect_pause, ...)
  if type(a:cmd) == 3
    let cmd_list = a:cmd
  elseif type(a:cmd) == 1
    let cmd_list = [(get(a:, 1, 1) ? 'call ' : '') . a:cmd]
  end
  if a:expect_pause && !s:win_gui
    call map(cmd_list, 'Silent(v:val)')
    let cmd_list += ["sil exe \"!bash -c 'read -sN1'\"", 'redraw!']
  end
  let cmd = ':<C-u>' . join(cmd_list, '<Bar>') . '<CR>'
  if a:map[0] ==# 'i'
    let cmd = '<C-o>' . cmd
  end
  let cmd = printf('%s <buffer> <silent> %s %s', a:map, a:key, cmd)
  if a:expect_pause && s:win_gui
    let cmd .= '<CR>'
  end
  exe cmd
endf
" }}}

" Windows Only {{{

" Call run.exe written in AHK
func! WinOpen(name, ...)
  let cmd = '!run '
  if get(a:, 2, 0)
    let cmd .= '*RunAs '
  end
  let cmd .= a:name
  if !get(a:, 1, 1)
    exe cmd
  else
    sil exe cmd
    if !s:win_gui
      redraw!
    end
  end
endf

com! -bar -nargs=1 SetAlpha call libcall('vimtweak.dll', 'SetAlpha', <args>)
" }}}

" Compile & Run -------------- {{{
let g:makefile_level = -1

func! Make(...)
  let dir = '.'
  let level = 0
  while 1
    if filereadable(dir . '/Makefile')
      exe printf('!cd %s && %s %s', dir, get(a:, 2, 'make'), get(a:, 1, ''))
      return 1
    end
    if g:makefile_level >= 0 && level >= g:makefile_level
      return 0
    end
    if fnamemodify(dir, ':p') == fnamemodify(dir . '/..', ':p')
      return 0
    end
    let dir .= '/..'
    let level += 1
  endw
endf

let g:cpp_std = 17
let g:c_std = 99

let g:cxxflags = []
let g:cflags = []
let g:ldlibs = []
if s:win
  call add(g:ldlibs, '-Wl,--stack=268435456')
end

func! Compile(...)
  up
  if &ft =~ '\v^(c|cpp)$'
    if !Make()
      if &ft == 'cpp'
        let bin = 'g++'
        if !s:win && g:cpp_std == 20
          let bin = 'g++-11'
        end
        let std = 'c++' . g:cpp_std
        let flags = copy(g:cxxflags)
      else
        let bin = 'gcc'
        let std = 'c' . g:c_std
        let flags = copy(g:cflags)
      end
      let flags += get(a:, 1, [])
      if join(flags) !~# '\(\s\|^\)-std='
        let flags += ['-std=' . std]
      end
      exe '!' . join([bin] + flags + ['-o "%<" "%"'] + g:ldlibs)
    end
  elseif &ft == 'java'
    !javac "%"
  elseif &ft == 'cuda'
    !nvcc -o "%<" -Xcompiler /utf-8 "%"
  elseif &ft == 'masm'
    call Make('', 'mingw32-make')
  elseif &ft == 'tex'
    !xelatex "%"
  elseif &ft =~ '^s[ca]ss$'
    !scss --style=expanded "%" "%<.css"
  end
endf

let g:run_args = ''

func! Run()
  if &ft =~ '\v^(c|cpp|cuda|masm)$'
    if !Make('run')
      exe '!"./%<" ' . g:run_args
    end
  elseif &ft == 'java'
    exe '!java "%<" ' . g:run_args
  elseif &ft == 'python'
    exe '!python3 "%" ' . g:run_args
  elseif &ft == 'ruby'
    exe '!ruby "%" ' . g:run_args
  elseif &ft == 'javascript'
    exe '!node "%" ' . g:run_args
  elseif &ft == 'scheme'
    exe '!gosh "%" ' . g:run_args
  elseif &ft == 'autohotkey'
    call WinOpen('"%"', 0)
  elseif &ft == 'tex'
    call WinOpen('"%<.pdf"')
  elseif &ft == 'markdown'
    MarkdownPreview
  else
    if !Make('run')
      if !s:win || expand('%:e') =~ '\v^(bat|vbs)$'
        !"./%"
      else
        call WinOpen('"%"')
      end
    end
  end
endf

func! Debug()
  if &ft =~ '\v^(c|cpp)$'
    if !Make('debug')
      call WinOpen('gdb "%<"')
    end
  end
endf
" ---------------------------- }}}

" Commands {{{
func! FakeCmdLine()
  let s = ''
  let t = 't'
  while 1
    if get(g:, 'cmdline_debug', 0)
      echo '^' . s
    else
      echo ':' . s
    end
    let c = getchar()
    if type(c) == 0
      let c = nr2char(c)
    end
    if c == "\<BS>"
      let s = s[:-2]
    else
      let s .= c
    end
    if s[:len(t) - 1] == t && s[len(t)] =~ '\W'
      return ':tabe' . s[len(t):]
    end
    if t[:len(s) - 1] != s && s =~ '\W'
      if s[-1:] == "\e"
        echo ''
        return "\e"
      end
      return ':' . s
    end
  endw
endf

func! TryFakeCmdLine()
  try
    return FakeCmdLine()
  catch
    nun :
    return ':'
  endt
endf

func! Quit()
  if !exists('b:stdin')
    q
  else
    q!
  end
endf

func! QuitAll()
  if bufnr('$') == 1
    call Quit()
  else
    qa
  end
endf

func! GetTextObj(key)
  let reg = @"
  let pos = getpos('.')
  exe "normal ya" . a:key
  let outer_text = @"
  let outer_lp = getpos("'[")
  let outer_rp = getpos("']")
  call setpos('.', pos)
  exe "normal yi" . a:key
  let inner_text = @"
  if len(outer_text) - len(inner_text) < 2
    return
  end
  let inner_lp = getpos("'[")
  let inner_rp = getpos("']")
  let left_text = GetText(outer_lp, inner_lp)[:-2]
  if empty(inner_text)
    let right_text = GetText(inner_lp, outer_rp)
  else
    let right_text = GetText(inner_rp, outer_rp)[1:]
  end
  call setpos('.', pos)
  let @" = reg
  return [[outer_lp, outer_rp], [left_text, inner_text, right_text]]
endf

func! CollapseTextObj(...)
  let key = a:0 ? a:1 : nr2char(getchar())
  let obj = GetTextObj(key)
  if empty(obj)
    return
  end
  let reg = @"
  let @" = RStrip(obj[1][0])
  call setpos("'<", obj[0][0])
  call setpos("'>", obj[0][1])
  normal! gvp`]
  let left_rp = getpos('.')
  let @" = Strip(obj[1][1])
  normal! p`]
  let inner_rp = getpos('.')
  let @" = LStrip(obj[1][2])
  normal! p
  call setpos('.', left_rp)
  let @" = reg
  return inner_rp
endf

func! ExpandTextObj(...)
  let inner_rp = call('CollapseTextObj', a:000)
  if empty(inner_rp)
    return
  end
  let left_rp = getpos('.')
  if inner_rp == left_rp
    exe "normal! a\n\n\ek"
  else
    call setpos('.', inner_rp)
    exe "normal! a\n\e"
    call setpos('.', left_rp)
    exe "normal! a\n\el"
  end
endf

func! ChangeSurround(key, sub)
  let obj = GetTextObj(a:key)
  let reg = @"
  let @" = a:sub[0] . LStrip(obj[1][0], '\S*')
        \ . obj[1][1]
        \ . RStrip(obj[1][2], '\S*') . a:sub[1]
  call setpos("'<", obj[0][0])
  call setpos("'>", obj[0][1])
  normal! gvp
  let @" = reg
endf

func! SeamlessJoin()
  let l = line('.')
  if l != line('$')
    let lines = getline(l, l + 1)
    call deletebufline('%', l + 1)
    call setline(l, lines[0] . LStrip(lines[1]))
  end
endf

func! Unwrap() range
  let range = a:firstline . ',' . a:lastline
  let reg = @"
  sil exe range . 'y'
  let str = @"
  let @" = reg
  let str = substitute(str, '-\s*\n\s*', '', 'g')
  let str = substitute(str, '\s*\n\s*', ' ', 'g')[:-2]
  call append(a:lastline, str)
  sil exe range . 'd _'
endf

com! -bar -range Join <line1>,<line2>call Unwrap()
com! -bar -range J <line1>,<line2>call Unwrap()

func! ClipAll()
  try
    %y +
    let @+ = @+[:-2]
  catch
    let fixeol = &fixeol
    let eol = &eol
    se nofixeol
    se noeol
    sil w !cb.exe --copy
    let &fixeol = fixeol
    let &eol = eol
  endt
endf

func! ClipVisual() range
  let reg = @"
  normal! gvy
  try
    let @+ = @"
  catch
    call system('cb.exe --copy', @")
  endt
  let @" = reg
endf

func! Clip() range
  let reg = @"
  exe a:firstline . ',' . a:lastline . 'y'
  let @" = @"[:-2]
  try
    let @+ = @"
  catch
    call system('cb.exe --copy', @")
  endt
  let @" = reg
endf

com! -bar -range Clip <line1>,<line2>call Clip()
com! -bar -range Y <line1>,<line2>call Clip()

func! VSub(...) range
  let pat = Input('Pattern: ')
  if pat == ''
    redraw
    echo
    return
  end
  let sub = Input('Substitute: ')
  redraw
  let pat = '\m\%V\%(' . pat . '\m\)'
  call TryExec(printf("'<,'>s/%s/%s/%s", pat, sub, get(a:, 1, '')), '486')
endf

func! VPut() range
  let reg = @"
  exe printf('normal! gv"%sp', v:register)
  let @" = reg
endf

func! ViewingMode()
  echo
  while 1
    let cmd = nr2char(getchar())
    if cmd ==# 'q' || cmd == "\e"
      break
    elseif cmd ==# 'Q'
      call QuitAll()
    elseif cmd ==# 'j'
      exe "normal! \<C-d>0"
    elseif cmd ==# 'k'
      exe "normal! \<C-u>0"
    elseif cmd ==# 'u'
      exe "normal! \<C-f>0"
    elseif cmd ==# 'i'
      exe "normal! \<C-b>0"
    elseif cmd ==# 'g'
      normal! gg0
    elseif cmd ==# 'G'
      normal! G0
    elseif cmd =~# '[tzb]'
      exe 'normal! z' . cmd
    elseif cmd =~# '[HML{}0$]'
      exe 'normal! ' . cmd
    end
    redraw
  endw
endf

func! CenterAfter(ncmd)
  call TryExec('normal! ' . a:ncmd, '486')
  if !empty(s:exception)
    return
  end
  if foldclosed(line('.')) != -1
    normal! zO
  end
  normal! zz
endf

func! ShowSearch(ncmd)
  if !empty(s:exception)
    return
  end
  if a:ncmd ==# 'n'
    if line(".") != line("''") ? line(".") > line("''") : col(".") > col("''")
      echo '/' . @/
    end
  elseif a:ncmd ==# 'N'
    if line(".") != line("''") ? line(".") < line("''") : col(".") < col("''")
      echo '?' . @/
    end
  end
endf

func! InsertTeXEnv()
  let reg = @"
  exe "normal! BC\\begin{}\n\\end{}\ePk$P$"
  let @" = reg
endf
" }}}

" ---------------------------- }}}
