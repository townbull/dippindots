# DippinDots

These are my personal dotfiles for OSX and Linux (in particular, Xubuntu, with iffy Crunchbang/ElementaryOS settings).
Please feel free to use/modify them as you like!

If you're on OSX, you should have XCode and the XCode Command Line Tools
installed before you begin. Make sure you open XCode at least once to agree to the
license.

You should also have your Github SSH keys (`id_rsa` and `id_rsa.pub`) in
`~/.ssh/` so login-less (SSH) Github access can be setup. You may need
to set proper permissions:
```bash
$ chmod 700 ~/.ssh
$ chmod 644 ~/.ssh/id_rsa.pub
$ chmod 600 ~/.ssh/id_rsa
$ chmod 600 ~/.ssh/config
```

## Usage
```bash
$ git clone https://github.com/ftzeng/dippindots.git ~/.dippindots
$ cd ~/.dippindots
$ ./dippindots.sh
```

Or, in one long line:
```bash
$ git clone https://github.com/ftzeng/dippindots.git ~/.dippindots && cd ~/.dippindots && ./dippindots.sh
```

To update the git submodules:
```bash
$ git submodule foreach git pull origin master
```

## Notes
If you've setup SSH access to GitHub but still have issues pushing
to GitHub repos, you may need to edit: `.git/config` and change the
`[remote "origin"]` `url` value to the format:
`git@github.com:username/repo.git`.

## What's included

### Vim
I have several vim plugins, managed as git submodules and located in `vim/bundle/`.

- language/framework support:
    - `scala`
    - `ruby`
    - `rails`
    - `python`
    - `processing`
    - `play`
    - `javascript`
    - `jinja`
    - `markdown`
    - `haml`
    - `jade`
- some extras for python (I spend most of my time in Python):
    - `cute-python`: eyecandy for python (conceals certain keywords as their mathematical symbols)
    - `jedi-vim`: code completion and other IDE-like fanciness for python
- `unite`: for searching through files via ctrl+p
- `vimproc`: dependency for `unite`
- `vim-airline`: nice status bar
- `nerdtree`: file tree browsing
- `nerdcommenter`: for easier commenting
- `vimroom`: for writing non-code text (prose, posts, etc)
- `tagbar`: high-level understanding of a file
- `syntastic`: syntax checking
- `surround`: for handling surrounding elements (parens, quotes, brackets, etc)
- `neocomplete`: code completion
- `futora`: my custom colorscheme
- `gitgutter`: for easily keeping track of changes b/w commits
- `delimitmate`: auto-closing of parens, quotes, brackets, etc
- `easymotion`: quick jumping through a file based on characters


## Credits
Credit for the foundation of these dotfiles goes to:
* [Mathias Bynen](http://mths.be/dotfiles)
* [Ben Alman](https://github.com/cowboy/dotfiles)
* [Carl Huda](https://github.com/carlhuda/janus)
