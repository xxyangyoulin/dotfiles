call plug#begin()

Plug 'ap/vim-css-color'

call plug#end()

set mouse=a

set clipboard=unnamed

nmap <Space> <Plug>(easymotion-s)


" 将 H 映射为 ^
map H ^
" 将 L 映射为 g_
map L g_
" 将 H 映射为 ^
vmap H ^
" 将 L 映射为 g_
vmap L g_
" 将 J 映射为 5j
map J 5j
" 将 K 映射为 5k
map K 5k
" 在可视模式下将 J 映射为 5j
vmap J 5j
" 在可视模式下将 K 映射为 5k
vmap K 5k

call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='ayu_dark'
call plug#end()

" call plug#begin('~/.vim/plugged')
" Plug 'lilydjwg/fcitx.vim'
" call plug#end()

" -------------------------------
" 自动切换 fcitx5-rime 输入法（Vim/Neovim 通用）
" -------------------------------

let g:fcitx_rime_status = 'true'  " true=英文, false=中文

function! GetRimeStatus()
  return trim(system("busctl call --user org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 IsAsciiMode"))
endfunction

function! RimeSetAsciiMode(val)
  call system("busctl call --user org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 SetAsciiMode b " . a:val)
endfunction

" 离开插入模式时：记录当前状态并切换为英文
autocmd InsertLeave * let g:fcitx_rime_status = GetRimeStatus() | call RimeSetAsciiMode('true')

" 进入插入模式时：如果上次是中文状态，则恢复中文
autocmd InsertEnter * if g:fcitx_rime_status ==# 'b false' | call RimeSetAsciiMode('false') | endif

