#!/bin/bash

# =============== WELCOME =================================
tput setaf 1
echo "Welcome to DippinDots, the dotfile of the future!"
tput setaf 4
echo "A customized version of Mathias Bynens' dotfiles (http://mths.be/dotfiles)"
echo "and Ben Alman's dotfiles (https://github.com/cowboy/dotfiles)."
tput sgr0



# ===============  OSX  =================================
echo "Checking OS..."
if [[ "$OSTYPE" =~ ^darwin ]]; then
  echo "You're running OSX!"
else
  tput setaf 1
	echo "You are not running OSX. Aborting!"
  tput sgr0
  exit 1
fi

ln -s ./vim ~/.vim
ln -s ./vim/vimrc ~/.vimrc
ln -s ./dots/bash_profile ~/.bash_profile



# =============== DOTFILES =================================
# Copy over our dotfiles.
echo "Copying over dotfiles..."
cd "$(dirname "${BASH_SOURCE}")"
#git pull
function doIt() {
  rsync --exclude ".git/" --exclude "bin/" --exclude ".DS_Store" --exclude "dippindots.sh" --exclude ".brew" --exclude ".gems" --exclude ".osx" --exclude "README.md" --exclude "brews/" --exclude ".weechat/" -av . ~
	sudo rsync bin / -av
}
if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
      doIt
  fi  
fi
unset doIt
source ~/.bash_profile



# =============== COMMAND LINE TOOLS =================================
# Check for Command Line Tools
echo "Checking for XCode Command Line Tools..."
if [[ ! "$(type -P gcc)" && "$OSTYPE" =~ ^darwin ]]; then
  echo "The XCode Command Line Tools must be installed first."
  echo "Sending you to the download page..."
  open "https://developer.apple.com/downloads/index.action?=command%20line%20tools"
  exit 1
fi



# =============== HOMEBREW =================================
echo "Checking for Homebrew..."
if [[ ! "$(type -P brew)" ]]; then
	echo "Installing Homebrew"
	true | ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
else
	echo "Homebrew found, moving on..."
fi



# =============== GIT =================================
# If Git is not installed...
echo "Checking for Git..."
if [[ ! "$(type -P git)" ]]; then
  echo "Git not found. Will try to install..."
	echo "Installing Git"
	brew install git
	brew link --overwrite git
else
  echo "Git found! Moving on..."
fi

# Configure git
echo "Now we need to configure git a bit."
tput setaf 4
echo "What's your git email?"
tput sgr0
read email
tput setaf 4
echo "What's your git name? Use your full name."
tput sgr0
read name
echo "\n[user]\n\temail = $email\n\tname = $name" >> ~/.gitconfig
# To bypass some symlink issues. Maybe too brute.
brew link --overwrite git
# So we can push without logging in
ssh -vT git@github.com
echo "gitconfig updated. Moving on..."

# If Git isn't installed by now, something messed up...here's the contigency plan.
if [[ ! "$(type -P git)" ]]; then
  tput setaf 1
  echo "Git should be installed. It isn't. Aborting."
  tput sgr0
  exit 1
fi



# =============== BREWS =================================
# Install Homebrew goodies
tput setaf 4
read -p "Do you want to install some Homebrew goodies? It's a good idea to do this on a fresh install. (y/n) " -n 1
tput sgr0
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo "\nInstalling some more Homebrew goodies..."
	echo "Running .brew (this may take awhile)"
	sh ./.brew
else
	echo "\nOk, just updating Homebrew stuff..."
	brew update
	brew upgrade
	brew cleanup
fi
echo "Brewing complete! Moving on..."



# =============== RVM & RUBY =================================
echo "Modifying bash_profile to include RVM..."
# Add the RVM load path to bash_profile
echo "\n[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function" >> ~/.bash_profile
source ~/.bash_profile
echo "Checking for RVM and Ruby..."
if [[ ! "$(type -P rvm)" ]]; then
  echo "RVM not found. Will try to install..."
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



# =============== PYTHON & PIP =================================
echo "Installing (homebrew) Python and pip...."
# Add the python path to bash_profile
echo "\nexport PATH=/usr/local/bin:/usr/local/share/python:$PATH" >> ~/.bash_profile
source ~/.bash_profile
brew install python
easy_install pip



# =============== VIM =================================
brew install vim


# =============== FONT CUSTOM =================================
# Installing fontcustom
# http://fontcustom.com/
echo "Installing fontcustom (http://fontcustom.com/)..."
brew install fontforge ttfautohint
gem install fontcustom



# =============== JANUS VIM PLUGINS & MORE =================================
echo "Installing Janus and other vim powerups..."
echo "\nChecking Janus dependencies..."
if [[ ! "$(type -P rake)" ]]; then
	echo "Rake not found, installing Rake..."
	gem install rake
else
	echo "Rake found!"
fi
if [[ ! "$(type -P ack)" ]]; then
	echo "ack not found, installing ack..."
	brew install ack
else
	echo "ack found!"
fi
if [[ ! "$(type -P ctags)" ]]; then
	echo "ctags not found, installing ctags..."
	brew install ctags
else
	echo "ctags found!"
fi

# First check if RVM/Ruby/Rake/ack/ctags are installed
echo "Changing existing .vimrc to .vimrc.after"
mv ~/.vimrc ~/.vimrc.after
echo "Installing Janus vim plugins..."
echo "(this may take awhile)"
curl -Lo- https://bit.ly/janus-bootstrap | bash
echo "Removing old vim files"
rm -rf ~/.vim.old
rm ~/.vimrc.old
rm ~/.gvimrc.old

echo "Adding some nice color schemes..."
cp -R ./init/colors/* ~/.vim/janus/vim/colors

echo "Installing Powerline..."
pip install --user git+git://github.com/Lokaltog/powerline
cp "./init/Inconsolata+for+Powerline.otf" ~/Library/Fonts

echo "Installing Processing syntax files..."
cp -r ./init/processing ~/.vim/janus/vim/langs/processing



# =============== WEECHAT =================================
tput setaf 4
read -p "Do you want to install Weechat? (y/n) " -n 1
tput sgr0
if [[ $REPLY =~ ^[Yy]$ ]]; then	
	echo "Installing Weechat (custom brew)..."
	sudo perl -MCPAN -e 'install Crypt::OpenSSL::Bignum, Crypt::DH, Crypt::Blowfish, Math::BigInt, MIME::Base64'
	cp -R .weechat ~/.weechat
	brew install ./brews/weechat.rb
	echo "Weechat has been installed. You will need to configure ~/.weechat/irc.conf with your nick credentials"
else
	echo "Skipping Weechat..."
fi



# =============== XVIM =================================
# Install XVim (Vim for XCode)
echo "Installing XVim (Vim for XCode)..."
git clone https://github.com/JugglerShu/XVim.git
xcodebuild -project XVim/XVim.xcodeproj
rm -rf XVim



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



# =============== GEMS =================================
echo "Installing some good gems..."
sh ./.gems



# =============== FIN! =================================
source ~/.bash_profile
tput setaf 4
echo "All done!"
tput sgr0
