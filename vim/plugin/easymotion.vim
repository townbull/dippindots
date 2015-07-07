" Bind to <Leader> instead of <Leader><Leader>
let g:EasyMotion_leader_key = '<Leader>'

" With this option set, v will match both v and V, but V will match V only.
let g:EasyMotion_smartcase = 1

" Ctrl-e to search
map  <C-e> <Plug>(easymotion-sn)
omap <C-e> <Plug>(easymotion-tn)
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)