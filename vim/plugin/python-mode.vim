" Don't override my existing syntax highlighting
let g:pymode_syntax = 0

" Auto-check for venv
let g:pymode_virtualenv = 1

" No pep8 linting
let g:pymode_lint_checkers = ['pyflakes', 'mccabe']

" Disable Rope until this gets fixed
" https://github.com/klen/python-mode/issues/525
let g:pymode_rope = 0
