" General -------------------- {{{

se nocp
se bs=2
se wak=no
se acd
se noswf
se enc=utf-8

se rtp+=~/.vim
se vi+=n~/.viminfo

" ---------------------------- }}}

" Mappings ------------------- {{{

mapc
mapc!

nn U <C-R>
nn <C-Q> <Nop>

nn <C-H> <C-W>h
nn <C-J> <C-W>j
nn <C-K> <C-W>k
nn <C-L> <C-W>l

vn <RightMouse> "+y

se noto
se ttimeout

let mapleader=' '

nn <leader>n :call CenterAfter('n')<CR>
nn <leader>N :call CenterAfter('N')<CR>
nn <leader>s :%s/\<<C-R><C-W>\>//g<Left><Left>

nn <F5> :call Debug()<CR>
nn <F6> :call Compile(['-O2'])<CR><CR>
nn <F7> :call Compile(['-g3'])<CR><CR>
nn <F8> :call Run()<CR><CR>
nn <F9> :call Run('call Compile(["-g3"])')<CR><CR>

"se kmp=dvorak

" ---------------------------- }}}

" Plugins -------------------- {{{

call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'gko/vim-coloresque'

Plug 'vim-ruby/vim-ruby'

Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'mattn/emmet-vim'

call plug#end()

ru! macros/matchit.vim

" NERDTree {{{
aug config_NERDTree
  au!
  au StdinReadPre * let s:std_in = 1
  au VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | end
  au BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | q | end
aug END

let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
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
  au BufEnter * if &bt == 'help' | winc L | end
aug END

let g:use_gui_colors = 1

if has('gui_running')
  se go=
  se gfn=ubuntu_mono:h14

  aug maximize_gui
    au!
    au GUIEnter * sim ~x
  aug END

else
  if has('win32') || has('win64')
    se nocuc
    se nocul
    let g:use_gui_colors = 0
  end

  if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    se tgc
  else
    let g:use_gui_colors = 0
  end
end

if g:use_gui_colors
  let g:gruvbox_italic = 0
  colo gruvbox
  se bg=dark
  let g:lightline = { 'colorscheme': 'gruvbox' }

else
  se t_Co=256
  colo desert
  let g:lightline = { 'colorscheme': 'selenized_dark' }
end

" ---------------------------- }}}

" Format --------------------- {{{

se ts=2
se sw=2
se et

" ---------------------------- }}}

" FileType-Specific ---------- {{{

let c_no_curly_error = 1

let g:ruby_indent_assignment_style = 'variable'

let g:tex_flavor = 'latex'

function! FileTypeConfig()
  if index(['cpp', 'c', 'python'], &ft) != -1
    setl ts=4
    setl sw=4
  end

  if index(['cpp', 'c'], &ft) != -1
    setl cino=:0,g0,N-s,(0,ws,Ws,j1,J1
    setl noet
  end

  if &ft == 'tex'
    setl inde=
    setl nocul
    setl nocuc
    setl wrap
    nn <F5> :call InsTexEnv()<CR>
    im <F5> <Esc><F5>a
  end
endf

aug file_type_config
  au!
  au BufEnter * call FileTypeConfig()
aug END

" ---------------------------- }}}

" Functions ------------------ {{{

" Utils ---------------------- {{{

function! CenterAfter(ncmd)
  exe 'norm! ' . a:ncmd
  if foldclosed(line('.')) != -1
    norm! zO
  end
  norm! zz
endf

function! InsTexEnv()
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
    echo
  elseif &ft == 'autohotkey'
    exe '!sudo "%"'
  else
    sil exe '!open "%"'
    echo
  end
endf

function! Debug()
  if &ft == 'cpp' || &ft == 'c'
    if !Make('debug')
      sil exe '!open gdb "%<"'
    end
    echo
  end
endf

" ---------------------------- }}}

" ---------------------------- }}}
