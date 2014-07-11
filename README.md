# DippinDots

These are my personal (OSX) dotfiles. Please feel free to use/modify them as
you like!

Before you begin, you should have XCode and the XCode Command Line Tools
installed. Make sure you open XCode at least once to agree to the
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

## Usage ##
```bash
$ git clone https://github.com/ftzeng/dippindots.git ~/.dippindots
$ cd ~/.dippindots
$ git submodule init && git submodule update
$ ./dippindots.sh
```

Or, in one long line:
```bash
$ git clone https://github.com/ftzeng/dippindots.git ~/.dippindots && cd ~/.dippindots && git submodule init && git submodule update && ./dippindots.sh
```

To update the git submodules:
```bash
$ git submodule foreach git pull origin master
```
You should probably run this at least once after you set things up.

## Credits ##
Credit for the foundation of these dotfiles goes to:
* [Mathias Bynen](http://mths.be/dotfiles)
* [Ben Alman](https://github.com/cowboy/dotfiles)
* [Carl Huda](https://github.com/carlhuda/janus)
