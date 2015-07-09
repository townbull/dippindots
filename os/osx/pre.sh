# =============== COMMAND LINE TOOLS =================================
tput setaf 4
echo "Checking for XCode Command Line Tools..."
tput sgr0

if [[ ! "$(type -P gcc)" ]]; then
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
	ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

    # So brew linking works.
    sudo chown -R $USER /usr/local/include
    sudo chown -R $USER /usr/local/lib

    # Make sure we’re using the latest Homebrew
    brew update

    # Upgrade any already-installed formulae
    brew upgrade

else
	tput setaf 2
	echo "Homebrew found! Moving on..."
	tput sgr0
fi

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

# =============== TERMINAL =================================
tput setaf 5
echo -e "\nConfiguring Terminal..."
tput sgr0

cp ./assets/com.apple.Terminal.plist ~/Library/Preferences/
