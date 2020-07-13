" General -------------------- {{{

se nocp
se bs=2
se wak=no
se noswf
se ffs=unix,dos
se enc=utf-8
se fencs=ucs-bom,utf-8,cp932,cp936,latin1

se rtp+=~/.vim,~/.vim/after
se vi+=n~/.viminfo

" Wait forever for mappings
se noto

" Wait no time for key codes
se ttimeout
se ttm=0

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

" Disable some keys {{{
sil! vu <C-x>

nn <C-q> <Nop>
" }}}

" Basic keys {{{
nn U <C-r>

no <silent> q :call Quit()<CR>
no <silent> Q :qa<CR>
no gq q

nn <C-h> <C-w>h
nn <C-j> <C-w>j
nn <C-k> <C-w>k
nn <C-l> <C-w>l

vn <RightMouse> "*y

ono ir i]
vn ir i]
ono ar a]
vn ar a]
ono ia i>
vn ia i>
ono aa a>
vn aa a>

nn ga <C-a>
vn ga g<C-a>
nn gx <C-x>
vn gx g<C-x>
" }}}

" Space leading keys {{{
no <Space>j <C-d>
no <Space>k <C-u>
nn <silent> <Space>w :up<CR>
nn <silent> <Space>r :redraw!<CR>
nn <silent> <Space>y :call ClipAll()<CR>
nn <silent> <Space>p :let &paste=!&paste<CR>
" }}}

" Search & Replace {{{
nn <silent> & :&&<CR>

nn gs :%s//g<Left><Left>
nn g* :%s/\<<C-r><C-w>\>//g<Left><Left>

vn <silent> s :call VSub('g')<CR>

nn <silent> crB :call SplitBraces()<CR>

nn <silent> <Space>n :call CenterAfter('n')<CR>:call ShowSearch('n')<CR>
nn <silent> <Space>N :call CenterAfter('N')<CR>:call ShowSearch('N')<CR>
" }}}

if s:win_gui
  nn <silent> <F8> :call Run()<CR><CR>
  nn <silent> <F9> :up<CR>:call Run()<CR><CR>
else
  nn <silent> <F8> :call Run()<CR>
  nn <silent> <F9> :up<CR>:call Run()<CR>
end

let g:mapleader=' '

no <M-x> :

ino <C-\><CR> <CR><Up><End><CR>
ino <C-\><BS> <Up><End><CR>

"se kmp=dvorak

" ---------------------------- }}}

" Plugins -------------------- {{{

call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'flosacca/vim-coloresque'

Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/tComment'
Plug 'terryma/vim-multiple-cursors'
Plug 'danro/rename.vim'
Plug 'tpope/vim-abolish'

Plug 'mattn/emmet-vim'

Plug 'vim-ruby/vim-ruby'
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-rails'
Plug 'gabrielelana/vim-markdown'

Plug 'iamcco/markdown-preview.nvim'

call plug#end()

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
  if exists('b:NERDTree')
    let path = b:NERDTree.root.path
    if s:win
      let full_path = join([path.drive] + path.pathSegments, '\')
    else
      let full_path = join([''] + path.pathSegments, '/')
    end
    exe 'cd ' . full_path
  else
    exe 'cd ' . expand('%:h')
  end
endf

aug auto_chdir
  au!
  au BufEnter,FileType * call AutoChdir()
aug END
" }}}

" Emmet {{{
let g:user_emmet_leader_key='<C-t>'

im <C-u> <Plug>(emmet-expand-abbr)
nm <C-u> <Plug>(emmet-expand-abbr)
vm <C-u> <Plug>(emmet-expand-abbr)
" }}}

" Others {{{
nm gS <Plug>TComment_gcc

let g:mkdp_auto_close = 0

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

let g:use_gui_colors = 1

if s:gui
  se go=
  se gfn=ubuntu_mono:h16

  aug maximize_gui
    au!
    au GUIEnter * sim ~x
  aug END

elseif $TERM !~ '256'
  let g:use_gui_colors = 0
  se nocuc
  se nocul
  let g:lightline = { 'colorscheme': 'nord' }

else
  if has('termguicolors')
    let &t_8f = "\e[38;2;%lu;%lu;%lum"
    let &t_8b = "\e[48;2;%lu;%lu;%lum"
    se tgc
  else
    let g:use_gui_colors = 0
  end
end

if !exists('g:lightline')
  let g:lightline = { 'colorscheme': 'gruvbox' }
end

if g:use_gui_colors
  let g:gruvbox_italic = 0
  colo gruvbox
  se bg=dark
  hi! link Operator GruvboxRed

else
  se t_Co=256
  colo desert
end

" ---------------------------- }}}

" Format --------------------- {{{

se ts=2
se sw=2
se et
se si

" ---------------------------- }}}

" File type specific --------- {{{

aug add_file_type
  au!
  au BufRead *.pgf se ft=tex
aug END

let g:c_no_curly_error = 1

let g:is_bash = 1
let g:sh_no_error = 1

let g:tex_flavor = 'latex'
let g:tex_no_error = 1

let g:ruby_indent_assignment_style = 'variable'

func! FileTypeConfig()
  setl fo-=ro

  if &ft =~ '\v^(c|cpp|make)$'
    setl ts=4
    setl sw=4
  end

  if &ft =~ '\v^(make)$'
    setl noet
  end

  if &ft =~ '\v^(c|cpp)$'
    setl cino=:0,g0,N-s,(s,ws,Ws,j1,J1,m1

    let f = [['<F5>', 'Debug()']]
    call add(f, ['<F6>', 'Compile(["-O2"])'])
    call add(f, ['<F7>', 'Compile(["-g3"])'])
    call add(f, ['<F9>', ['call Compile(["-g3"])', 'call Run()']])

    for i in range(4)
      call LSMap('nn', f[i][0], f[i][1], f[i][0] != '<F5>')
    endfor
  end

  if &ft == 'markdown'
    call LSMap('nn', '<F8>', 'Run()', 0)
    call LSMap('ino', '<F8>', 'Run()', 0)
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
    call LSMap('nn', '<F7>', 'Compile()', 1)
    call LSMap('nn', '<F9>', ['call Compile()', 'call Run()'], 1)
  end

  if &ft =~ '^eruby'
    ino <buffer> <C-\>j <%  %><Left><Left><Left>
    ino <buffer> <C-\>k <%=  %><Left><Left><Left>
  end
endf

func! PureTextConfig()
  if &ft =~ '\v^(text)$' && &bt != 'help'
    setl nocuc
    setl nocul
    setl wrap
    if s:win_gui
      setl slm=mouse
      star
    end
  end
endf

aug file_type_config
  au!
  au BufEnter * call FileTypeConfig()
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
    let cmd = join(cmd, '<Bar>')
  elseif get(a:, 1, 1)
    let cmd = 'call ' . cmd
  end
  let cmd = ':' . cmd . '<CR>'
  if a:map[0] ==# 'i'
    let cmd = '<C-o>' . cmd
  end
  let cmd = printf('%s <buffer> <silent> %s %s', a:map, a:key, cmd)
  if a:expect_pause && s:win_gui
    exe cmd . '<CR>'
  else
    exe cmd
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
  let dir = '.'
  while 1
    if filereadable(dir . '/Makefile')
      exe printf('!cd %s && make %s', dir, a:0 ? a:1 : '')
      return 1
    end
    if fnamemodify(dir, ':p') == fnamemodify(dir . '/..', ':p')
      return 0
    end
    let dir .= '/..'
  endw
endf

let g:cxxflags = ['-std=c++14']
let g:cflags = ['-std=c99']

func! Compile(...)
  up
  if &ft =~ '\v^(c|cpp)$'
    if !Make()
      let ld_flags = []
      if s:win
        let ld_flags += ['-Wl,--stack=268435456']
      end

      if &ft == 'cpp'
        let cmd = ["g++", g:cxxflags]
      else
        let cmd = ['gcc', g:cflags]
      end
      let flags = cmd[1] + get(a:, 1, [])

      exe '!' . join([cmd[0]] + flags + ['-o "%<" "%"'] + ld_flags)
    end
  elseif &ft == 'tex'
    !xelatex "%"
  end
endf

func! Run()
  if &ft == 'autohotkey'
    call WinOpen('"%"', 0, 1)
  elseif &ft =~ '\v^(c|cpp)$'
    if !Make('run')
      !"./%<"
    end
  elseif &ft == 'markdown'
    MarkdownPreview
  elseif &ft == 'python'
    !python3 "%"
  elseif &ft == 'ruby'
    !ruby "%"
  elseif &ft == 'tex'
    call WinOpen('"%<.pdf"')
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

func! SplitBraces()
  exe "norm! viB\el%ls\n\e``%hs\n"
endf

func! ClipAll()
  try
    %y *
    let @* = @*[:-2]
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
  exe "norm! B\"cy$C\\begin{}\n\\end{}\e\"cPk$\"cP$"
endf
" }}}

" ---------------------------- }}}
