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

    # build from source with shared libraries,
    # so Julia's PyCall has access to Python3's libpython
    PYVERSION=3.5.0
    wget https://www.python.org/ftp/python/${PYVERSION}/Python-${PYVERSION}.tar.xz -O /tmp/
    cd /tmp
    tar xfv Python-${PYVERSION}.tar.xz
    cd Python-${PYVERSION}
    ./configure --prefix=/usr/local --enable-shared

    # make this way so the binary knows where to find the shared libs
    LD_RUN_PATH=/usr/local/lib make
    sudo make install
fi

ln -sf $DIR/dots/pystartup ~/.pystartup
