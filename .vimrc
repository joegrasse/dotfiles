syntax on
colorscheme molokai

set hidden

set path+=/usr2/ps/isp/include/sys
set path+=/usr2/ps/isp/src/sys

" airline config
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" neocomplete config
set completeopt-=preview
let g:neocomplete#enable_at_startup = 1

" Tagbar config
let g:tagbar_left = 1
let g:tagbar_previewwin_pos = ''

" vim-go config
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"

" Go related mappings
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <Leader>t <Plug>(go-test)
au FileType go nmap <Leader>i <Plug>(go-install)
au FileType go nmap <Leader>in <Plug>(go-info)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
au FileType go nmap <silent> <F9> <Plug>(go-def-split)

nnoremap <silent> <F10> :bp<CR>
nnoremap <silent> <F11> :bn<CR>
nnoremap <silent> <F12> :ToggleBufExplorer<CR>
nnoremap <leader><Leader> :call ToggleIDEView()<CR>

" Auto close NERDTree if last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Configure Plugins
call plug#begin()

" Make sure you use single quotes

" sensible.vim
Plug 'tpope/vim-sensible'

" Go Support
Plug 'fatih/vim-go'

" Class outline viewer
Plug 'majutsushi/tagbar'

" Autocomplete
Plug 'Shougo/neocomplete.vim'

" File browser
" Plug 'vim-scripts/netrw.vim'

" NERD Tree
Plug 'scrooloose/nerdtree'

Plug 'vim-airline/vim-airline'

Plug 'jlanzarotta/bufexplorer'

" Add plugins to &runtimepath
call plug#end()

function! ToggleIDEView()
    let w:jumpbacktohere = 1

    " Detect which plugins are open
    if exists('t:NERDTreeBufName')
        let nerdtree_open = bufwinnr(t:NERDTreeBufName) != -1
    else
        let nerdtree_open = 0
    endif
    let tagbar_open = bufwinnr('__Tagbar__') != -1
    
    if nerdtree_open && tagbar_open
        NERDTreeClose
        TagbarClose
        set nonumber
    else
        set number
        if nerdtree_open
            TagbarOpen
            
            " find NERDTree
            let nerdtree_window = bufwinnr(t:NERDTreeBufName)
            " Move to NERDTree
            execute nerdtree_window . 'wincmd w'
            " Move NERDTree left
            wincmd H
        elseif tagbar_open
            NERDTree
            
            " move NERDTree left
            wincmd H
        else
            TagbarOpen
            NERDTree
            
            " move NERDTree left
            wincmd H
        endif
        
        " move windows into position
        wincmd l
        wincmd J
        wincmd k
        wincmd l
        wincmd L
        wincmd h
        vertical resize 30
    endif   
    
    " Jump back to the original window
    for window in range(1, winnr('$'))
        execute window . 'wincmd w'
        if exists('w:jumpbacktohere')
            unlet w:jumpbacktohere
            break
        endif
    endfor
endfunction
