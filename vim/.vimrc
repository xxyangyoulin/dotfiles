
let fcitx5state=system("fcitx5-remote")
" 退出插入模式时禁用输入法，并保存状态
autocmd InsertLeave * :silent let fcitx5state=system("fcitx5-remote")[0] | silent !fcitx5-remote -c
" 2 表示之前状态打开了输入法，则进入插入模式时启动输入法
autocmd InsertEnter * :silent if fcitx5state == 2 | call system("fcitx5-remote -o") | endif

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
