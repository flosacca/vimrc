" vimrc

" General -------------------- {{{

se nocp
se bs=2
se wak=no
se noswf
se ffs=unix,dos
se enc=utf-8
se fencs=ucs-bom,utf-8,cp932,cp936,latin1

se rtp^=~/.vim
se rtp+=~/.vim/after
se vi+=n~/.viminfo

" Wait forever for mappings
se noto

" Wait no time for key codes
se ttimeout
se ttm=0

se kp=
se nosol

let s:win = has('win32') || has('win64')
let s:gui = has('gui_running')
let s:win_gui = s:win && s:gui

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
" }}}

" Basic keys {{{
nn U <C-r>

no <silent> q :call Quit()<CR>
no <silent> Q :call QuitAll()<CR>
nn gq q

nn <silent> <Space>w :up<CR>

vn <silent> p :<C-u>call VPut()<CR>
vn P "0p
vn gp p

no gg gg0
" }}}

" Moving {{{
no <Space>h gT
no <Space>l gt

no <Space>j <C-d>
no <Space>k <C-u>
no <Space>u <C-f>
no <Space>i <C-b>
no <silent> <Space>v :<C-u>call ViewingMode()<CR>

no <C-h> <C-w>h
no <C-j> <C-w>j
no <C-k> <C-w>k
no <C-l> <C-w>l
" }}}

" Search & Replace {{{
nn <silent> & :&&<CR>

nn gs :%s//g<Left><Left>
nn g* :%s/\<<C-r><C-w>\>//g<Left><Left>

" vn <silent> s :call VSub('g')<CR>
vn s :s//g<Left><Left>

nn <silent> crv :call SplitBraces()<CR>

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
" }}}

" Utils {{{
nn ga <C-a>
vn ga g<C-a>
nn gx <C-x>
vn gx g<C-x>
nn <C-a> ga

nn gt :tabe<Space>
nn <silent> <Space>r :redraw!<CR>
nn <silent> <Space>p :let &paste=!&paste<CR>

ino <C-\><CR> <End><CR>
ino <C-\><BS> <Up><End><CR>
ino <C-\>e <CR><Up><End><CR>

cno ` <C-r>

vn <LeftMouse> <Esc>gv"+y
nn <silent> <Space>y :call ClipAll()<CR>

" if s:win_gui
"   nn <silent> <F8> :call Run()<CR><CR>
"   nn <silent> <F9> :up<CR>:call Run()<CR><CR>
" else
"   nn <silent> <F8> :call Run()<CR>
"   nn <silent> <F9> :up<CR>:call Run()<CR>
" end

no <M-x> :
cno <M-j> <Down>
cno <M-k> <Up>

" se kmp=dvorak
" }}}

" ---------------------------- }}}

" Plugins -------------------- {{{

let s:plug_path = '~/.vim/autoload/plug.vim'

func! GetPlug()
  let url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  sil exe printf('!curl --create-dirs -sLo %s %s', s:plug_path, url)
  return v:shell_error == 0
endf

if empty(glob(s:plug_path))
  if GetPlug()
    au VimEnter * PlugInstall --sync | so $MYVIMRC
  end
end

let g:has_plug = !empty(glob(s:plug_path))

if g:has_plug
  call plug#begin('~/.vim/plugged')
else
  com! -nargs=* Plug
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
Plug 'rust-lang/rust.vim'
Plug 'gabrielelana/vim-markdown'
Plug 'vim-language-dept/css-syntax.vim'
Plug 'leafOfTree/vim-vue-plugin'
Plug 'rhysd/vim-llvm'
Plug 'dylon/vim-antlr'
Plug 'gko/vim-coloresque'
" --------------------------------

" Operation ----------------------
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/tComment'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-abolish'
Plug 'danro/rename.vim'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-rails'
" --------------------------------

" Extern -------------------------
Plug 'iamcco/markdown-preview.nvim'
" --------------------------------

" Plug 'kana/vim-fakeclip'
" Plug 'kana/vim-altr'
" Plug 'kana/vim-submode'
" Plug 'kana/vim-arpeggio'
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
let g:NERDTreeMapQuit = '<C-q>'

nn <silent> <Space>t :NERDTreeToggle<CR>

" This doesn't work when editing a new dir
let g:NERDTreeChDirMode = 2

func! AutoChdir()
  let full_path = expand('%:h')
  if exists('b:NERDTree')
    let path = b:NERDTree.root.path
    if s:win
      let full_path = join([path.drive] + path.pathSegments, '\')
    else
      let full_path = join([''] + path.pathSegments, '/')
    end
  end
  exe 'cd ' . substitute(expand('%:h'), '\', '/', 'g')
endf

aug auto_chdir
  au!
  au BufEnter,FileType * call AutoChdir()
aug END
" }}}

" Emmet {{{
im <C-u> <Plug>(emmet-expand-abbr)
nm <C-u> <Plug>(emmet-expand-abbr)
vm <C-u> <Plug>(emmet-expand-abbr)

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

if exists('*textobj#user#plugin')
  call textobj#user#plugin('latex', {
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
end
" }}}

" Others {{{
map gn <Plug>TComment_gcc

let g:mkdp_auto_close = 0

let g:mkdp_preview_options = { 'disable_sync_scroll': 1 }

let g:markdown_enable_spell_checking = 0

let g:multi_cursor_select_all_word_key = 'g<C-n>'
" }}}

" ---------------------------- }}}

" View ----------------------- {{{

se nu
se ru
se cuc
se cul
se nowrap
se fdm=marker
se ls=2
se nosmd

aug move_help_window
  au!
  au BufRead * if &bt == 'help' | winc L | end
aug END

if exists('$NOBLINK')
  let &t_ti .= "\e[2 q"
  let &t_SI .= "\e[6 q"
  let &t_SR .= "\e[4 q"
  let &t_EI .= "\e[2 q"
  let &t_te .= "\e[4 q"
else
  let &t_ti .= "\e[1 q"
  let &t_SI .= "\e[5 q"
  let &t_SR .= "\e[3 q"
  let &t_EI .= "\e[1 q"
  let &t_te .= "\e[3 q"
end

if s:gui
  se go=
  se gfn=ubuntu_mono:h14

  aug maximize_gui
    au!
    au GUIEnter * sim ~x
  aug END

elseif $TERM !~ '256'
  let g:no_gui_colors = 1

else
  if has('termguicolors')
    let &t_8f = "\e[38;2;%lu;%lu;%lum"
    let &t_8b = "\e[48;2;%lu;%lu;%lum"
    se tgc
  else
    let g:no_gui_colors = 1
  end
end

if empty(getcompletion('gruvbox', 'color'))
  let g:no_gui_colors = 1
end

if !get(g:, 'no_gui_colors', 0)
  se bg=dark
  let g:gruvbox_italic = 0
  colo gruvbox
  hi! link Operator GruvboxRed
  let g:lightline = { 'colorscheme': 'gruvbox' }

else
  se t_Co=256
  se nocuc
  se nocul
  colo desert
end

" ---------------------------- }}}

" Format --------------------- {{{

com! -nargs=1 Tab setl ts=<args> | setl sw=0 | setl sts=-1

se ts=2
se sw=0
se sts=-1
se et
se si

aug add_file_type
  au!
  au BufRead * call AddFileType()
aug END

func! AddFileType()
  let ext = expand('%:e')
  if ext ==? 'pgf'
    se ft=tex
  elseif ext ==? 's'
    " se ft=asm
  elseif ext =~? '\v^(asm|inc)$'
    se ft=masm
  end
endf

let g:c_no_curly_error = 1

let g:is_bash = 1
let g:sh_no_error = 1

let g:tex_flavor = 'latex'
let g:tex_no_error = 1

let g:python_highlight_all = 1
let g:python_highlight_space_errors = 0

let g:ruby_indent_assignment_style = 'variable'

let g:vim_vue_plugin_use_scss = 1
let g:vim_vue_plugin_highlight_vue_attr = 1
let g:vim_vue_plugin_highlight_vue_keyword = 1

hi link jsParensError NONE

func! FileTypeConfig()
  setl fo-=ro

  call LSMap('nn', '<F8>', 'Run()', 1)
  call LSMap('nn', '<F9>', ['up', 'call Run()'], 1)

  if &ft =~ '\v^((make|c|cpp|java|masm)$|antlr)'
    setl ts=4
  end

  if &ft =~ '\v^(make)$'
    setl noet
  end

  if &ft == '\v^(vue)$'
    setl isk+=-
  end

  if &ft =~ '\v^(c|cpp|java)$'
    setl cino=:0,g0,N-s,(s,ws,Ws,j1,J1,m1
  end

  if &ft =~ '\v^(python|ruby)$'
    com! NextDef call search('\v^\s*(def|class)>')
    com! PrevDef call search('\v^\s*(def|class)>', 'b')
    call LSMap('no', ']f', 'NextDef', 0, 0)
    call LSMap('no', '[f', 'PrevDef', 0, 0)
  end

  if &ft =~ '\v^(c|cpp)$'
    call LSMap('nn', '<F5>', 'Debug()', 0)
    call LSMap('nn', '<F6>', 'Compile(["-O2"])', 1)
    call LSMap('nn', '<F7>', 'Compile(["-g3"])', 1)
    call LSMap('nn', '<F9>', ['call Compile(["-g3"])', 'call Run()'], 1)
  end

  if &ft =~ '\v^(java|masm|tex)$'
    call LSMap('nn', '<F7>', 'Compile()', 1)
    call LSMap('nn', '<F9>', ['call Compile()', 'call Run()'], 1)
  end

  if &ft =~ '^s[ca]ss$'
    call LSMap('nn', '<F7>', 'Compile()', 1)
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
  if &fenc == 'latin1' && &bt != 'help'
    se ft=text
    setl fdm=manual
    setl bin
    %!xxd
    setl nobin
  end
endf

func! BinWritePre()
  if &fenc == 'latin1'
    let b:cursor_pos = getpos('.')
    %y c
    %s/\v^(\x{8}:)? ?((\x\x)+( (\x\x)+)*)?( *|  .*)$/\2/g
    %!xxd -p -r
    setl bin
  end
endf

func! BinWritePost()
  if &fenc == 'latin1'
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
      setl slm=mouse
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

" ---------------------------- }}}

" Functions ------------------ {{{

" Utils ---------------------- {{{
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

func! LSMap(map, key, cmd, expect_pause, ...)
  let cmd = a:cmd
  if type(cmd) == 3
    if a:expect_pause && !s:win_gui
      call map(cmd, '"sil " . v:val')
    end
    let cmd = join(cmd, '<Bar>')
  elseif get(a:, 1, 1)
    let cmd = 'call ' . cmd
    if a:expect_pause && !s:win_gui
      let cmd = 'sil ' . cmd
    end
  end
  " TODO
  if a:expect_pause && !s:win_gui
    let pause_cmd = [
\      'sil exe "!echo && echo Press any key to continue"',
\      'sil exe "!read -sN1"',
\      'redraw!'
\    ]
    let cmd = join([':<C-u>' . cmd] + pause_cmd, '<Bar>') . '<CR>'
  else
    let cmd = ':<C-u>' . cmd . '<CR>'
  end
  if a:map[0] ==# 'i'
    let cmd = '<C-o>' . cmd
  end
  let cmd = printf('%s <buffer> <silent> %s %s', a:map, a:key, cmd)
  exe cmd
  if a:expect_pause
    if s:win_gui
      exe cmd . '<CR>'
    end
  end
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

com! -nargs=1 SetAlpha call libcall('vimtweak.dll', 'SetAlpha', <args>)
" }}}

" Compile & Run -------------- {{{
func! Make(...)
  if expand('%:e') =~ '\v^(|h)$'
    !cpp-syntax "%"
    return 1
  end
  let dir = '.'
  while 1
    if filereadable(dir . '/Makefile')
      exe printf('!cd %s && %s %s', dir, get(a:, 2, 'make'), get(a:, 1, ''))
      return 1
    end

    " prevent further search
    return 0

    if fnamemodify(dir, ':p') == fnamemodify(dir . '/..', ':p')
      return 0
    end
    let dir .= '/..'
  endw
endf

let g:cxxflags = ['-std=c++14']
let g:cflags = ['-std=c99']
let g:ldflags = []
if s:win
   call add(g:ldflags, '-Wl,--stack=268435456')
end

func! Compile(...)
  up
  if &ft =~ '\v^(c|cpp)$'
    if !Make()
      if &ft == 'cpp'
        let cmd = ["g++", g:cxxflags]
      else
        let cmd = ['gcc', g:cflags]
      end
      let flags = cmd[1] + get(a:, 1, [])
      exe '!' . join([cmd[0]] + flags + ['-o "%<" "%"'] + g:ldflags)
    end
  elseif &ft == 'java'
    !javac "%"
  elseif &ft == 'masm'
    call Make('', 'mingw32-make')
  elseif &ft == 'tex'
    !xelatex "%"
  elseif &ft =~ '^s[ca]ss$'
    !scss --style=expanded "%" "%<.css"
  end
endf

func! Run()
  if &ft =~ '\v^(c|cpp|masm)$'
    if !Make('run')
      !"./%<"
    end
  elseif &ft == 'java'
    !java "%<"
  elseif &ft == 'python'
    !python3 "%"
  elseif &ft == 'ruby'
    !ruby "%"
  elseif &ft == 'javascript'
    !node "%"
  elseif &ft == 'autohotkey'
    call WinOpen('"%"', 0, 1)
  elseif &ft == 'tex'
    call WinOpen('"%<.pdf"')
  elseif &ft == 'markdown'
    MarkdownPreview
  else
    if !s:win || expand('%:e') =~ '\v^(bat|vbs)$'
      !"./%"
    else
      call WinOpen('"%"')
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

func! SplitBraces()
  exe "norm! viB\el%ls\n\e``%hs\n"
endf

func! ClipAll()
  try
    %y +
    let @+ = @+[:-2]
  catch
    let fixeol = &fixeol
    let eol = &eol
    se nofixeol
    se noeol
    sil w !clip.exe
    let &fixeol = fixeol
    let &eol = eol
  endt
endf

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
  exe printf('norm! gv"%sp', v:register)
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
      exe "norm! \<C-d>0"
    elseif cmd ==# 'k'
      exe "norm! \<C-u>0"
    elseif cmd ==# 'u'
      exe "norm! \<C-f>0"
    elseif cmd ==# 'i'
      exe "norm! \<C-b>0"
    elseif cmd ==# 'g'
      norm! gg0
    elseif cmd ==# 'G'
      norm! G0
    elseif cmd == '0'
      norm! 0
    elseif cmd == '$'
      norm! $
    end
    redraw
  endw
endf

func! CenterAfter(ncmd)
  call TryExec('norm! ' . a:ncmd, '486')
  if s:exception != ''
    return
  end
  if foldclosed(line('.')) != -1
    norm! zO
  end
  norm! zz
endf

func! ShowSearch(ncmd)
  if s:exception != ''
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
  exe "norm! BC\\begin{}\n\\end{}\ePk$P$"
  let @" = reg
endf
" }}}

" ---------------------------- }}}
