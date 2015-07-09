OS=$1
DIR=$2

tput setaf 5
echo "Installing Vim..."
tput sgr0

if [ $OS = 'osx' ]; then
    # Necessary for Vim Plugins
    brew install ctags
    brew install aspell

    brew install macvim --with-features=huge --with-lua --with-python3 --override-system-vim
    brew linkapps
    brew link --overwrite macvim

    # Copy over necessary fonts
    cp "./assets/Inconsolata+for+Powerline.otf" ~/Library/Fonts
    cp "./assets/Inconsolata-dz.otf" ~/Library/Fonts

    # Note: you may need to re-install Homebrew MacVim by manually adding:
    #   args << "--enable-pythoninterp=dynamic" << "--enable-python3interp=dynamic"
    # so that it compiles with +python/dyn & +python3/dyn, which at the moment jedi-vim requires.

elif [ $OS = 'debian' ]; then
    # Lua
    sudo apt-get install lua5.1 liblua5.1-dev -y

    # X11, allows using system clipboard with vim.
    sudo apt-get install libx11-dev libxtst-dev libxt-dev libsm-dev libxpm-dev -y

    mkdir /tmp/vim && cd $_
    wget ftp://ftp.ca.vim.org/pub/vim/unix/vim-7.4.tar.bz2
    tar xvjf vim-7.4.tar.bz2
    cd vim*
    ./configure --with-features=huge --enable-luainterp=yes --enable-pythoninterp=yes --enable-python3interp=yes --enable-gui=gtk2 --with-x --with-lua-prefix=/usr
    make -s && sudo make install
    cd $DIR

    # Overwrite vi
    sudo rm /usr/bin/vi
    sudo ln -s /usr/local/bin/vim /usr/bin/vi
fi

# Jedi for jedi-vim (python completion)
sudo pip install jedi

# Build vimproc
cd vim/bundle/vimproc/
make -s
cd $DIR
