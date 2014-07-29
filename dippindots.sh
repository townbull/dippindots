#!/bin/bash

# =============== WELCOME =================================
tput setaf 6
echo "Welcome to DippinDots, the dotfiles of the future!"
tput setaf 2
echo "Starting up..."
tput sgr0

tput setaf 3
read -p "This will overwrite your existing dotfiles. Do you want to continue?. (y/n) " -n 1
tput sgr0
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	echo -e "\nExiting..."
	exit 1
fi



# ===============  OS SETUP  ================================
tput setaf 4
echo -e "\nChecking OS..."
tput sgr0
if [[ "$OSTYPE" =~ ^darwin ]]; then
	tput setaf 2
    echo "Running setup for OSX ~"
    ./setup/osx
	tput sgr0
elif [[ -f /etc/debian_version ]]; then
  tput setaf 2
	echo "Running setup for Debian ~"
    ./setup/debian
  tput sgr0
else
  tput setaf 1
	echo "DippinDots is meant for use with OSX or Debian-based Linux distros. Goodbye!"
  tput sgr0
  exit 1
fi

# =============== RVM & RUBY =================================
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


# =============== GEMS =================================
tput setaf 5
read -p "Do you want install some gems? (y/n) " -n 1
tput sgr0
if [[ $REPLY =~ ^[Yy]$ ]]; then
	tput setaf 5
	echo "Installing some gems..."
	tput sgr0

	bash ./init/gems
else
	tput setaf 3
	echo -e "\nSkipping gems...\n"
	tput sgr0
fi



# ===============  SYMLINK  =================================
tput setaf 5
echo "Symlinking dotfiles..."
tput sgr0

pwd=$(pwd)

# Clear out old files
rm -rf ~/.vim

# Symlink files
ln -sf $pwd/vim ~/.vim
ln -sf $pwd/vim/vimrc ~/.vimrc
ln -sf $pwd/dots/bash_profile ~/.bash_profile
ln -sf $pwd/dots/bashrc ~/.bashrc
ln -sf $pwd/dots/inputrc ~/.inputrc
ln -sf $pwd/bin ~/.bin
ln -sf $pwd/dots/tmux.conf ~/.tmux.conf

if [ ! -f /etc/environment ]; then
    # Create an empty env file.
    echo "Creating an empty environment variables file at /etc/environment..."
    sudo touch /etc/environment
fi


if [ ! -f ~/.temp_aliases ]; then
    # Create an empty temporary alias file.
    echo "Creating an empty temporary alias file at ~/.temp_aliases"
    sudo touch ~/.temp_aliases
fi


# =============== FIN! =================================
source ~/.bash_profile
tput setaf 4
echo "All done!"
tput sgr0
