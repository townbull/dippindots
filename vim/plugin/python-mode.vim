" Don't override my existing syntax highlighting
let g:pymode_syntax = 0

" Auto-check for venv
let g:pymode_virtualenv = 1

" No pep8 or mccabe complexity linting
let g:pymode_lint_checkers = ['pyflakes']

" Disable Rope until this gets fixed
" https://github.com/klen/python-mode/issues/525
let g:pymode_rope = 0

"let g:pymode_python = 'python3'

" With multiple windows, PymodeLint doesn't seem to autorun
" This is a temp fix, see https://github.com/klen/python-mode/issues/374
au BufWriteCmd *.py write || :PymodeLint
