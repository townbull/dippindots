OS=$1
DIR=$2

if [[ ! "$(type -P node)" ]]; then
    tput setaf 5
    echo "Installing Node..."
    tput sgr0

    if [ $OS = 'osx' ]; then
        brew install node

    elif [ $OS = 'debian' ]; then
        mkdir /tmp/nodejs && cd $_
        wget -N http://nodejs.org/dist/node-latest.tar.gz
        tar xzvf node-latest.tar.gz && cd `ls -rd node-v*`
        ./configure
        sudo make install -s
        cd $DIR
    fi
else
    tput setaf 2
    echo "Node found! Moving on..."
    tput sgr0
fi

if [[ ! "$(type -P grunt)" ]]; then
	tput setaf 5
	echo "Installing Grunt (grunt-cli)..."
	tput sgr0

	npm -g install grunt-cli
else
    tput setaf 2
    echo "Grunt found! Moving on..."
    tput sgr0
fi

if [[ ! "$(type -P bower)" ]]; then
	tput setaf 5
	echo "Installing Bower..."
	tput sgr0

	npm -g install bower
else
    tput setaf 2
    echo "Bower found! Moving on..."
    tput sgr0
fi

if [[ ! "$(type -P yo)" ]]; then
	tput setaf 5
	echo "Installing Yeoman..."
	tput sgr0

	npm -g install yo
else
    tput setaf 2
    echo "Yeoman found! Moving on..."
    tput sgr0
fi
