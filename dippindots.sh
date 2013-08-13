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



# ===============  OSX  =================================
tput setaf 4
echo -e "\nChecking OS..."
tput sgr0
if [[ "$OSTYPE" =~ ^darwin ]]; then
	tput setaf 2
  echo "You're running OSX!"
	tput sgr0
else
  tput setaf 1
	echo "DippinDots is meant for use with OSX. Goodbye!"
  tput sgr0
  exit 1
fi



# =============== COMMAND LINE TOOLS =================================
tput setaf 4
echo "Checking for XCode Command Line Tools..."
tput sgr0

if [[ ! "$(type -P gcc)" && "$OSTYPE" =~ ^darwin ]]; then
  tput setaf 1
  echo "The XCode Command Line Tools must be installed first."
	tput sgr0

  echo "Sending you to the download page..."
  open "https://developer.apple.com/downloads/index.action?=command%20line%20tools"
  exit 1
fi



# =============== HOMEBREW =================================
if [[ ! "$(type -P brew)" ]]; then
	tput setaf 5
	echo "Installing Homebrew..."
	tput sgr0

	# Install Homebrew
	ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

else
	tput setaf 2
	echo "Homebrew found! Moving on..."
	tput sgr0
fi



# =============== GIT =================================
sh ./init/git

# If Git isn't installed by now, something messed up...here's the contigency plan.
if [[ ! "$(type -P git)" ]]; then
  tput setaf 1
  echo "Git should be installed. It isn't. Aborting."
  tput sgr0
  exit 1
fi



# =============== BREWS =================================

tput setaf 5
read -p "Do you want install some brews? (y/n) " -n 1
tput sgr0
if [[ $REPLY =~ ^[Yy]$ ]]; then
	tput setaf 5
	echo -e "\nInstalling some more Homebrew goodies..."
	echo "(this may take awhile)"
	tput sgr0

	sh ./init/brews

	tput setaf 2
	echo "Brewing complete! Moving on..."
	tput sgr0
else
	tput setaf 3
	echo -e "\nSkipping brews...\n"
	tput sgr0
fi





# =============== RVM & RUBY =================================
if [[ ! "$(type -P rvm)" ]]; then
	tput setaf 5
  echo "RVM not found. Will try to install..."

	echo "Installing RVM dependencies..."
	tput sgr0
	brew install autoconf automake libtool libyaml libxml2 libxslt libksba openssl

	tput setaf 5
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

	sh ./init/gems
else
	tput setaf 3
	echo -e "\nSkipping gems...\n"
	tput sgr0
fi



# =============== PYTHON & PIP =================================
tput setaf 5
echo "Installing (Homebrew) Python2, Python3, pip, and virtualenv...."
tput sgr0

brew install python 	# Brew Python includes pip
brew install python3
pip install virtualenv
pip3 install virtualenv



# =============== VIM =================================
tput setaf 5
echo "Installing MacVim as system Vim..."
tput sgr0

brew install macvim --override-system-vim
brew linkapps
brew link --overwrite macvim

# Copy over necessary fonts
cp "./assets/Inconsolata+for+Powerline.otf" ~/Library/Fonts
cp "./assets/Inconsolata-dz.otf" ~/Library/Fonts



# =============== XVIM =================================
tput setaf 5
read -p "Do you want install Vim bindings for XCode (XVim)? (y/n) " -n 1
tput sgr0
if [[ $REPLY =~ ^[Yy]$ ]]; then
	tput setaf 5
	echo "Installing XVim (Vim for XCode)..."
	tput sgr0

	# Install XVim (Vim for XCode)
	git clone https://github.com/JugglerShu/XVim.git
	xcodebuild -project XVim/XVim.xcodeproj
	rm -rf XVim
else
	tput setaf 3
	echo -e "\nSkipping XVim...\n"
	tput sgr0
fi



# =============== FONT CUSTOM =================================
if [[ ! "$(type -P fontcustom)" ]]; then
  tput setaf 5
  echo "Installing fontcustom (http://fontcustom.com/)..."
  tput sgr0
  brew install fontforge ttfautohint
  gem install fontcustom
else
  tput setaf 2
  echo "Font Custom found! Moving on..."
  tput sgr0
fi



# =============== NODE & GRUNT =================================
if [[ ! "$(type -P node)" ]]; then
  tput setaf 5
  echo "Installing Node..."
  tput sgr0

  brew install node
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

if [[ ! "$(type -P jam)" ]]; then
	tput setaf 5
	echo "Installing JamJS..."
	tput sgr0

	npm -g install jamjs
else
  tput setaf 2
  echo "Jam found! Moving on..."
  tput sgr0
fi



# =============== TERMINAL =================================
tput setaf 5
echo -e "\nConfiguring Terminal..."
tput sgr0

cp ./assets/com.apple.Terminal.plist ~/Library/Preferences/



# =============== OSX SETUP  =================================
if [[ "$OSTYPE" =~ ^darwin ]]; then
  tput setaf 5
  read -p "Since you're running OSX, do you want to do some additional setup? This is a good idea for a fresh install. (y/n) " -n 1
  tput sgr0
  if [[ $REPLY =~ ^[Yy]$ ]]; then
		tput setaf 2
    echo -e "\nOk, running .osx"
		tput sgr0

    sh ./init/osx
  else
		tput setaf 4
    echo -e "\nOk, skipping..."
		tput sgr0
  fi 
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
ln -sf $pwd/dots/screenrc ~/.screenrc
ln -sf $pwd/bin ~/.bin



# =============== FIN! =================================
source ~/.bash_profile
tput setaf 4
echo "All done!"
tput sgr0
