OS=$1

tput setaf 5
echo "Installing Git..."
tput sgr0

if [ $OS = 'osx' ]; then
    brew install git
    brew link --overwrite git

elif [ $OS = 'debian' ]; then
    # For `add-apt-repository`
    sudo apt-get install --no-install-recommends python-software-properties software-properties-common -y
    sudo add-apt-repository ppa:git-core/ppa -y
    sudo apt-get update
    sudo apt-get install git -y
fi

# Configure Git
# If gitconfig doesn't exist, set it up.
if [ ! -f ~/.gitconfig ]; then
    echo -e "\nNow we need to configure git a bit."
    tput setaf 5
    read -rep "What's your git email?" email
    tput sgr0
    tput setaf 5
    read -rep "What's your git name? Use your full name." name
    tput sgr0
    printf "\n[user]\n\temail = $email\n\tname = $name" >> ~/.gitconfig
    git config --global push.default simple
fi

# Requires your SSH keys!
tput setaf 5
read -rep "Do you want to setup Github SSH access? This requires that your SSH keys are available in ~/.ssh. (y/n) " -n 1
tput sgr0
if [[ $REPLY =~ ^[Yy]$ ]]; then

    if [ $OS = 'osx' ]; then
        # To bypass some symlink issues. Maybe too brute.
        brew link --overwrite git
        git config --global credential.helper osxkeychain
    fi

	# So we can push without logging in
	ssh -vT git@github.com

	tput setaf 2
	echo "gitconfig updated. Moving on..."
	tput sgr0
else
	tput setaf 3
	echo -e "\nNo SSH keys found, or user skipped, skipping git config..."
	tput sgr0
fi
