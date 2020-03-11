" General -------------------- {{{

se nocp
se bs=2
se wak=no
se acd
se noswf
se ffs=unix,dos
se enc=utf-8
se fencs=ucs-bom,utf-8,cp932,cp936,latin1

se rtp+=~/.vim,~/.vim/after
se vi+=n~/.viminfo

let s:win = has('win32') || has('win64')
let s:gui = has('gui_running')
let s:win_gui = s:win && s:gui

se noto
se ttimeout
se ttm=0

" ---------------------------- }}}

" Global Mappings ------------ {{{

" Disable some keys {{{
sil! vu <C-x>

nn <Space> <Nop>
for s:cmd in ['x', 'X', 's', 'S']
  if maparg(s:cmd, 'v') == ''
    exe 'vn ' . s:cmd . ' <Nop>'
  end
endfor

nn <C-q> <Nop>
" }}}

" Basic keys {{{
nn U <C-r>

nn <silent> q :q<CR>
nn <silent> Q :qa<CR>
nn gq q

vn <RightMouse> "*y

ono ir i]
vn ir i]
ono ar a]
vn ar a]
ono ia i>
vn ia i>
ono aa a>
vn aa a>

nn <C-h> <C-w>h
nn <C-j> <C-w>j
nn <C-k> <C-w>k
nn <C-l> <C-w>l
" }}}

" Space leading keys {{{
no <Space>j <C-d>
no <Space>k <C-u>
nn <silent> <Space>w :up<CR>
nn <silent> <Space>y :call ClipAll()<CR>
nn <silent> <Space>p :let &paste=!&paste<CR>
" }}}

" Search & Replace {{{
nn <silent> & :&&<CR>
nn gs :%s//g<Left><Left>
nn g* :%s/\<<C-r><C-w>\>//g<Left><Left>
vn <silent> s :call VSub()<CR>

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
Plug 'mattn/emmet-vim'
Plug 'danro/rename.vim'
Plug 'tpope/vim-abolish'

Plug 'vim-ruby/vim-ruby'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-rails'

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
let g:NERDTreeIgnore = ['^ntuser.*\c']

let g:NERDTreeMapHelp = 'K'
let g:NERDTreeMapQuit = '<C-q>'

nn <silent> <Space>t :NERDTreeToggle<CR>
" }}}

nm gS <Plug>TComment_gcc

let g:mkdp_auto_close = 0

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
  au BufEnter * if &bt == 'help' | winc L | end
aug END

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
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
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

let g:ruby_indent_assignment_style = 'variable'

let g:tex_flavor = 'latex'

func! FileTypeConfig()
  setl fo-=ro

  if &ft =~ '\v^(c|cpp|make)$'
    setl ts=4
    setl sw=4
  end

  if &ft =~ '\v^(c|cpp|make)$'
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
    im <buffer> <silent> <F8> <C-o><F8>
  end

  if &ft == 'tex'
    setl inde=
    setl nocul
    setl nocuc
    setl wrap

    call LSMap('nn', '<F5>', 'InsertTeXEnv()', 0)
    im <buffer> <silent> <F5> <C-o><F5>
    call LSMap('nn', '<F7>', 'Compile()', 1)
    call LSMap('nn', '<F9>', ['call Compile()', 'call Run()'], 1)
  end
endf

func! PureTextConfig()
  if &ft =~ '\v^(markdown|text)$'
    setl nocuc
    setl nocul
    setl wrap
    setl slm=mouse
    star
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
  let cmd = printf('%s <buffer> <silent> %s :%s<CR>', a:map, a:key, cmd)
  if a:expect_pause && s:win_gui
    exe cmd . '<CR>'
  else
    exe cmd
  end
endf
" }}}

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

func! SetAlpha(alpha)
  call libcall('vimtweak.dll', 'SetAlpha', a:alpha)
endf

" Compile & Run -------------- {{{
func! Make(...)
  for dir in ['.', '..', '../..']
    if filereadable(dir . '/Makefile')
      if !a:0
        exe '!cd ' . dir . ' && make'
      else
        if a:1 != 'debug'
          exe '!cd ' . dir . ' && make ' . a:1
        else
          sil exe '!cd ' . dir . ' && make debug'
        end
      end
      return 1
    end
  endfor
endf

func! Compile(...)
  up
  if &ft =~ '\v^(c|cpp)$'
    if !Make()
      let basic_flags = []
      if s:win
        let basic_flags += ['-Wl,--stack=268435456']
      end
      if &ft == 'cpp'
        let flags = ['-std=c++14']
      else
        let flags = ['-std=c99']
      end
      if a:0
        for flag in a:1
          if flag =~# '-std'
            let flags = []
            break
          end
        endfor
        let flags += a:1
      end
      if &ft == 'cpp'
        exe join(['!g++'] + flags + ['-o "%<" "%"'] + basic_flags)
      else
        exe join(['!gcc'] + flags + ['-o "%<" "%"'] + basic_flags)
      end
    end
  elseif &ft == 'tex'
    exe '!xelatex "%"'
  end
endf

func! Run()
  if &ft == 'autohotkey'
    call WinOpen('"%"', 0, 1)
  elseif &ft =~ '\v^(c|cpp)$'
    if !Make('run')
      exe '!"./%<"'
    end
  elseif &ft == 'markdown'
    MarkdownPreview
  elseif &ft == 'python'
    exe '!python "%"'
  elseif &ft == 'ruby'
    exe '!ruby "%"'
  elseif &ft == 'tex'
    call WinOpen('"%<.pdf"')
  else
    if !s:win || expand('%:e') =~ '\v^(bat|vbs)$'
      exe '!"./%"'
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

func! VSub() range
  let pat = Input('Pattern: ')
  if pat == ''
    redraw
    echo
    return
  end
  let sub = Input('Substitute: ')
  redraw
  call TryExec('''<,''>s/\m\%V\%(' . pat . '\m\)/' . sub . '/g', '486')
endf

func! ClipAll()
  %y *
  if @*[-1:] == "\n"
    let @* = @*[:-2]
  end
endf

func! InsertTeXEnv()
  exe "norm! ^\"yy$C\\begin{}\<CR>\\end{}\<Esc>\"yPk$\"yP$"
endf
" }}}

" ---------------------------- }}}
