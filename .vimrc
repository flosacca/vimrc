" General -------------------- {{{

se nocp
se bs=2
se wak=no
se acd
se noswf
se enc=utf-8

se rtp+=~/.vim
se vi+=n~/.viminfo

let s:win = has('win32') || has('win64')
let s:gui = has('gui_running')
let s:win_gui = s:win && s:gui

" ---------------------------- }}}

" Global Mappings ------------ {{{

" Preparation {{{
if !exists('g:default_map_cleared')
  mapc
  mapc!
  let g:default_map_cleared = 1
end

se noto
se ttimeout
se ttm=0
" }}}

let g:mapleader=' '

" Basic {{{
nn U <C-R>

nn <Space> <Nop>
nn <C-Q> <Nop>

for s:cmd in ['x', 'X', 's', 'S']
  if maparg(s:cmd, 'v') == ''
    exe 'vn ' . s:cmd . ' <Nop>'
  end
endfor

nn <C-H> <C-W>h
nn <C-J> <C-W>j
nn <C-K> <C-W>k
nn <C-L> <C-W>l

vn <RightMouse> "+y

nn <Space>j <C-D>
nn <Space>k <C-U>
nn <silent> <Space>q :q<CR>
nn <silent> <Space>Q :qa<CR>
nn <silent> <Space>w :up<CR>
" }}}

nn <silent> & :&&<CR>
nn gs :%s//g<Left><Left>
nn g* :%s/\<<C-R><C-W>\>//g<Left><Left>
vn <silent> s :call VSub()<CR>

nn <silent> <Space>n :call CenterAfter('n')<CR>:call ShowMessage('n')<CR>
nn <silent> <Space>N :call CenterAfter('N')<CR>:call ShowMessage('N')<CR>

nm gS <Plug>TComment_gcc

" EasyMotion {{{
map gj <Plug>(easymotion-j)
map gk <Plug>(easymotion-k)
nm go <Plug>(easymotion-overwin-line)

" Within line {{{
function! MultibyteToggle(...)
  if a:0
    let enable = a:1
  elseif exists('g:multibyte_motion')
    let enable = !g:multibyte_motion
  else
    return
  end
  let g:multibyte_motion = l:enable

  if !l:enable
    let g:EasyMotion_re_line_anywhere = '\v(\s|^)\zs\S'
    map gh <Plug>(easymotion-bl)
    map gl <Plug>(easymotion-wl)
    map gH <Plug>(easymotion-linebackward)
    map gL <Plug>(easymotion-lineforward)

  else
    let g:EasyMotion_re_line_anywhere = '[^\x00-\x7f]'
    map gh <Plug>(easymotion-linebackward)
    map gl <Plug>(easymotion-lineforward)
    map gH <Nop>
    map gL <Nop>
  end
endf

call MultibyteToggle(0)
" }}}

nn <silent> g<Space> :call MultibyteToggle()<CR>

map gb <Plug>(easymotion-b)
map gw <Plug>(easymotion-w)
map gB <Plug>(easymotion-ge)
map gW <Plug>(easymotion-e)
" }}}

nn <silent> <Space>t :NERDTreeToggle<CR>

if s:win_gui
  nn <silent> <F8> :call Run()<CR><CR>
  nn <silent> <F9> :up<CR>:call Run()<CR><CR>
else
  nn <silent> <F8> :call Run()<CR>
  nn <silent> <F9> :up<CR>:call Run()<CR>
end

"se kmp=dvorak

" ---------------------------- }}}

" Plugins -------------------- {{{

call plug#begin('~/.vim/plugged')

Plug 'danro/rename.vim'

Plug 'vim-ruby/vim-ruby'

Plug 'flazz/vim-colorschemes'
Plug 'morhetz/gruvbox'
Plug 'gko/vim-coloresque'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'

Plug 'vim-scripts/tComment'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'easymotion/vim-easymotion'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-rails'

call plug#end()

ru! macros/matchit.vim

" NERDTree {{{
aug config_NERDTree
  au!
  au StdinReadPre * let s:std_in = 1
  au VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | end
aug END

let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
let g:NERDTreeIgnore = ['^ntuser.*\c']
" }}}

let g:EasyMotion_keys = 'asdfghwertyuiopcvbnmlkj'

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
  se gfn=ubuntu_mono:h14

  aug maximize_gui
    au!
    au GUIEnter * sim ~x
  aug END

elseif s:win
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

if use_gui_colors
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

" ---------------------------- }}}

" FileType-Specific ---------- {{{

let g:c_no_curly_error = 1

let g:ruby_indent_assignment_style = 'variable'

let g:tex_flavor = 'latex'

function! FileTypeConfig()
  setl fo-=ro

  if index(['cpp', 'c', 'python'], &ft) != -1
    setl ts=4
    setl sw=4
  end

  if index(['cpp', 'c'], &ft) != -1
    setl cino=:0,g0,N-s,(0,ws,Ws,j1,J1
    setl noet
    nn <buffer> <silent> <F5> :call Debug()<CR>
    if s:win_gui
      nn <buffer> <silent> <F6> :call Compile(['-O2'])<CR><CR>
      nn <buffer> <silent> <F7> :call Compile(['-g3'])<CR><CR>
      nn <buffer> <silent> <F9> :call Run('call Compile(["-g3"])')<CR><CR>
    else
      nn <buffer> <silent> <F6> :call Compile(['-O2'])<CR>
      nn <buffer> <silent> <F7> :call Compile(['-g3'])<CR>
      nn <buffer> <silent> <F9> :call Run('call Compile(["-g3"])')<CR>
    end
  end

  if &ft == 'tex'
    setl inde=
    setl nocul
    setl nocuc
    setl wrap
    nn <buffer> <silent> <F5> :call InsertTeXEnv()<CR>
    im <buffer> <silent> <F5> <C-O><F5>
  end
endf

aug file_type_config
  au!
  au BufEnter * call FileTypeConfig()
aug END

" ---------------------------- }}}

" Functions ------------------ {{{

" Utils ---------------------- {{{

" Center after search {{{
function! CenterAfter(ncmd)
  let s:has_error = 0
  try
    exe 'norm! ' . a:ncmd
  catch /^Vim\%((\a\+)\)\?:E486/
    echoh ErrorMsg
    echom substitute(v:exception, '^Vim\%((\a\+)\)\?:', '', '')
    echoh None
    let s:has_error = 1
    return
  endt

  if foldclosed(line('.')) != -1
    norm! zO
  end
  norm! zz
endf

function! ShowMessage(ncmd)
  if s:has_error
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
"}}}

function! VSub() range
  call inputsave()
  let pat = input('Pattern: ')
  let sub = input('Substitute: ')
  call inputrestore()
  exe '''<,''>s/\%V\%(' . pat . '\)/' . sub . '/g'
endf

function! SetAlpha(alpha)
  call libcall('vimtweak.dll', 'SetAlpha', a:alpha)
endf

function! InsertTeXEnv()
  exe "norm! ^\"yy$C\\begin{}\<CR>\\end{}\<Esc>\"yPk$\"yP$"
endf

" ---------------------------- }}}

" Compile & Run -------------- {{{

function! Make(...)
  for dir in ['.', '..']
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

function! Compile(...)
  up
  if &ft == 'cpp' || &ft == 'c'
    if !Make()
      let basic_flags = ['-posix', '-Wl,--stack=268435456']
      if &ft == 'cpp'
        let flags = ['-std=c++11']
      else
        let flags = ['-std=c99']
      end
      if a:0
        for flag in a:1
          if flag =~ '-std'
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
  end
  if &ft == 'tex'
    exe '!xelatex "%"'
  end
endf

function! Run(...)
  if a:0
    exe a:1
  end
  if &ft == 'cpp' || &ft == 'c'
    if !Make('run')
      exe '!"./%<"'
    end
  elseif &ft == 'python'
    exe '!python "%"'
  elseif &ft == 'ruby'
    exe '!ruby "%"'
  elseif &ft == 'tex'
    sil exe '!open "%<.pdf"'
  elseif &ft == 'autohotkey'
    exe '!sudo "%"'
  else
    sil exe '!open "%"'
  end
endf

function! Debug()
  if &ft == 'cpp' || &ft == 'c'
    if !Make('debug')
      sil exe '!open gdb "%<"'
    end
  end
endf

" ---------------------------- }}}

" ---------------------------- }}}
