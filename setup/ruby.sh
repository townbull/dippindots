OS=$1

tput setaf 5
echo "Installing Ruby..."
tput sgr0
if [ $OS = 'osx' ]; then
	tput setaf 5
	echo "Installing RVM dependencies..."
	tput sgr0
	brew install autoconf automake libtool libyaml libxml2 libxslt libksba openssl

    if [[ ! "$(type -P rvm)" ]]; then
        tput setaf 5
        echo "RVM not found. Will try to install..."
        echo "Installing RVM, Ruby, and RubyGems..."
        tput sgr0

        # Install RVM w/ Ruby
        curl -L https://get.rvm.io | bash -s stable --ruby

        source ~/.rvm/scripts/rvm
    else
        tput setaf 2
        echo "RVM found! Moving on..."
        tput sgr0
    fi

    # Need to ensure RVM was installed properly
    if [[ ! "$(type -P rvm)" ]]; then
      tput setaf 1
      echo "RVM should be installed. It isn't. Aborting."
      tput sgr0
      exit 1
    fi

elif [ $OS = 'debian' ]; then
    sudo apt-get install ruby rubygems ruby-dev -y
fi


tput setaf 5
read -rep "Do you want install some gems? (y/n) " -n 1
tput sgr0
if [[ $REPLY =~ ^[Yy]$ ]]; then
    tput setaf 5
    echo "Installing some gems..."
    tput sgr0

    gem install rake
    gem install sass
    gem install tmuxinator
else
    tput setaf 3
    echo -e "\nSkipping gems...\n"
    tput sgr0
fi
