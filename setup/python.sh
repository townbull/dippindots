OS=$1
DIR=$2

tput setaf 5
echo "Installing Python2, Python3, pip, and virtualenv..."
tput sgr0
if [ $OS = 'osx' ]; then
    brew install python 	# Brew Python includes pip
    brew install python3
    pip install virtualenv
    pip3 install virtualenv

elif [ $OS = 'debian' ]; then
    sudo apt-get install python3 python-pip -y
    sudo pip install virtualenv

    sudo apt-get install python3-setuptools -y
    sudo easy_install3 pip
    sudo pip3 install virtualenv
fi

ln -sf $DIR/dots/pystartup ~/.pystartup
