set background=light
set nocursorcolumn
setlocal spell
set complete+=kspell

syn match markdownCheckboxUnchecked "^\s*\[\s\]" contained
syn match markdownCheckboxChecked "^\s*\[X\]" contained
syn match markdownUnchecked "^\s*\[\s\] .*$" contains=markdownCheckboxUnchecked
syn match markdownChecked "^\s*\[X\] .*$" contains=markdownCheckboxChecked