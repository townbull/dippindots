OS=$1
DIR=$2

tput setaf 5
echo "Installing Neovim..."
tput sgr0

if [ $OS = 'osx' ]; then
    # Necessary for Vim Plugins
    brew install ctags
    brew install aspell

    brew tap neovim/homebrew-neovim
    brew install --HEAD neovim

    # Neovim python interpreter
    pip install neovim

    # Copy over necessary fonts
    cp "./assets/osx/Inconsolata+for+Powerline.otf" ~/Library/Fonts
    cp "./assets/osx/Inconsolata-dz.otf" ~/Library/Fonts

elif [ $OS = 'debian' ]; then
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt-get update
    sudo apt-get install neovim
    pip install neovim
fi

# Jedi for jedi-vim (python completion)
sudo pip install jedi

# Build vimproc
cd vim/bundle/vimproc/
make -s
cd $DIR

# Reuse vim stuff for neovim
ln -sf $DIR/vim ~/.nvim
ln -sf $DIR/vim/vimrc ~/.nvimrc
