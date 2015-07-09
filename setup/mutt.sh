OS=$1
DIR=$2

if [ $OS = 'osx' ]; then
    brew install mutt
    brew install w3m
    brew install urlview
    brew install pandoc
    brew install aspell

elif [ $OS = 'debian' ]; then
    sudo apt-get install --yes mutt w3m urlview pandoc
fi

cp $DIR/dots/mutt/_aliases $DIR/dots/mutt/aliases
cp $DIR/dots/mutt/_auth $DIR/dots/mutt/auth
cp $DIR/dots/mutt/_signature $DIR/dots/mutt/signature
sudo ln -s $DIR/dots/mutt ~/.mutt
echo "Setup ~/.mutt/aliases, ~/.mutt/auth, and ~/.mutt/signature as needed!"
