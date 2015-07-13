#!/bin/bash
DIR=$(pwd)

# =============== WELCOME =================================
tput setaf 6
echo "Welcome to DippinDots, the dotfiles of the future!"
tput setaf 2
echo "Starting up..."
tput sgr0

tput setaf 3
read -rep "This will overwrite your existing dotfiles. Do you want to continue?. (y/n) " -n 1
tput sgr0
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	echo -e "\nExiting..."
	exit 1
fi

tput setaf 2
echo "Select which setup scripts you want to include:"
tput sgr0
declare -a available=(python ruby npm vim nvim util math mutt social apps)
declare -a selections=()
for s in "${available[@]}"; do
    read -rep "Include ${s}? (y/n) " -n 1
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        selections=("${selections[@]}" "${s}")
    fi
done

# ===============  OS CHECK  ================================
tput setaf 4
echo -e "\nChecking OS..."
tput sgr0
if [[ "$OSTYPE" =~ ^darwin ]]; then
    OS=osx
	tput setaf 2
    echo "Running setup for OSX ~"
	tput sgr0

elif [[ -f /etc/debian_version ]]; then
    OS=debian
    tput setaf 3
    echo "Running setup for Debian (or a derivative) ~"
    tput sgr0

else
    tput setaf 1
	echo "DippinDots is meant for use with OSX or Debian-based Linux distros. Goodbye!"
    tput sgr0
    exit 1
fi

# =============== GIT =================================
bash setup/git.sh $OS $DIR

# If Git isn't installed by now, something messed up
if [[ ! "$(type -P git)" ]]; then
  tput setaf 1
  echo "Git should be installed. It isn't. Aborting."
  tput sgr0
  exit 1
fi

# =============== SUBMODULES =================================
tput setaf 5
echo "Installing and updating git submodules..."
tput sgr0
git submodule init && git submodule update
git submodule foreach git pull origin master

# ===============  SETUP  ===================================
tput setaf 5
echo "Running setup..."
tput sgr0
bash os/$OS/pre.sh
for s in "${selections[@]}"; do
    bash setup/${s}.sh $OS $DIR
done
bash os/$OS/post.sh


# ===============  SYMLINK  =================================
tput setaf 5
echo "Symlinking dotfiles..."
tput sgr0

# Clear out old files
rm -rf ~/.vim

# Symlink files
ln -sf $DIR/vim ~/.vim
ln -sf $DIR/vim/vimrc ~/.vimrc
ln -sf $DIR/dots/bash_profile ~/.bash_profile
ln -sf $DIR/dots/bashrc ~/.bashrc
ln -sf $DIR/dots/inputrc ~/.inputrc
ln -sf $DIR/bin ~/.bin
ln -sf $DIR/dots/tmux.conf ~/.tmux.conf

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
