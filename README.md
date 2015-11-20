# DippinDots

These are my personal dotfiles for OSX and Linux (Lubuntu).
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
$ ./update
```

## Notes
If you've setup SSH access to GitHub but still have issues pushing
to GitHub repos, you may need to edit: `.git/config` and change the
`[remote "origin"]` `url` value to the format:
`git@github.com:username/repo.git`.
