#!/bin/bash

# =============== WELCOME =================================
tput setaf 1
echo "Welcome to DippinDots, the dotfiles of the future!"
tput setaf 4
echo "Starting up..."
tput sgr0



# ===============  OSX  =================================
echo "Checking OS..."
if [[ "$OSTYPE" =~ ^darwin ]]; then
  echo "You're running OSX!"
else
  tput setaf 1
	echo "DippinDots is meant for use with OSX. Goodbye!"
  tput sgr0
  exit 1
fi



# =============== COMMAND LINE TOOLS =================================
# Check for Command Line Tools
echo "Checking for XCode Command Line Tools..."
if [[ ! "$(type -P gcc)" && "$OSTYPE" =~ ^darwin ]]; then
  tput setaf 1
  echo "The XCode Command Line Tools must be installed first."
	tput sgr0
  echo "Sending you to the download page..."
  exit 1
  open "https://developer.apple.com/downloads/index.action?=command%20line%20tools"
fi






# =============== HOMEBREW =================================
echo "Checking for Homebrew..."
if [[ ! "$(type -P brew)" ]]; then
	tput setaf 4
	echo "Installing Homebrew..."
	tput sgr0
	true | ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
else
	echo "Homebrew found, moving on..."
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
# Install Homebrew goodies
echo "\nInstalling some more Homebrew goodies..."
echo "(this may take awhile)"
sh ./init/brews
echo "Brewing complete! Moving on..."



# =============== RVM & RUBY =================================
echo "Checking for RVM and Ruby..."
if [[ ! "$(type -P rvm)" ]]; then
  echo "RVM not found. Will try to install..."
	echo "Installing RVM dependencies..."
	brew install autoconf automake libtool libyaml libxml2 libxslt libksba openssl
	echo "Installing RVM, Ruby, and RubyGems..."
	\curl -L https://get.rvm.io | bash -s stable --ruby
else
  echo "RVM found!"
fi

# Need to ensure RVM was installed properly
if [[ ! "$(type -P rvm)" ]]; then
  tput setaf 1
  echo "RVM should be installed. It isn't. Aborting."
  tput sgr0
  exit 1
fi


# =============== GEMS =================================
echo "Installing some gems..."
sh ./init/gems



# =============== PYTHON & PIP =================================
echo "Installing (Homebrew) Python2, Python3, pip, and virtualenv...."
brew install python 	# Brew Python includes pip
brew install python3
pip install virtualenv



# =============== VIM =================================
echo "Installing Homebrew Vim..."
brew install vim
cp "./assets/Inconsolata+for+Powerline.otf" ~/Library/Fonts



# =============== XVIM =================================
# Install XVim (Vim for XCode)
echo "Installing XVim (Vim for XCode)..."
git clone https://github.com/JugglerShu/XVim.git
xcodebuild -project XVim/XVim.xcodeproj
rm -rf XVim



# =============== FONT CUSTOM =================================
echo "Installing fontcustom (http://fontcustom.com/)..."
brew install fontforge ttfautohint
gem install fontcustom



# =============== NODE & GRUNT =================================
echo "Installing Node..."
brew install node
echo "Installing Grunt (grunt-cli)..."
npm -g install grunt-cli



# =============== GEMS =================================
echo "Installing some good gems..."
sh ./.gems



# =============== OSX SETUP  =================================
if [[ "$OSTYPE" =~ ^darwin ]]; then
  tput setaf 4
  read -p "Since you're running OSX, do you want to do some additional setup? This is a good idea for a fresh install. (y/n) " -n 1
  tput sgr0
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "\nOk, running .osx"
    sh ./.osx
  else
    echo "\nOk, skipping..."
  fi 
fi



# ===============  SYMLINK  =================================
tput setaf 4
echo "Symlinking dotfiles..."
tput sgr0
ln -s ./vim ~/.vim
ln -s ./vim/vimrc ~/.vimrc
ln -s ./dots/bash_profile ~/.bash_profile
source ~/.bash_profile



# =============== FIN! =================================
source ~/.bash_profile
tput setaf 4
echo "All done!"
tput sgr0
