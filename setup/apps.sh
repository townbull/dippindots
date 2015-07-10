OS=$1
DIR=$2

tput setaf 5
echo -e "\nInstalling some more goodies..."
tput sgr0
if [ $OS = 'debian' ]; then
    # Note: Some of this is tailored for my Ubuntu 14.04 (HugeGreenBug's distro) C720 laptop, beware!

    # Remove stuff - so much bloatware on Ubuntu now
    sudo apt-get purge unity-webapps-common empathy-common brasero-common thunderbird rhythmbox libreoffice* gnome-mahjongg gnome-mines gnome-sudoku aisleriot intel-linux-graphics-installer gnome-orca transmission-common remmina* shotwell* unity-lens-friends unity-scope-audacious unity-scope-chromiumbookmarks unity-scope-clementine unity-scope-colourlovers unity-scope-devhelp unity-scope-firefoxbookmarks unity-scope-gdrive unity-scope-gmusicbrowser unity-scope-gourmet unity-scope-guayadeque unity-scope-manpages unity-scope-musicstores unity-scope-musique unity-scope-openclipart unity-scope-texdoc unity-scope-tomboy unity-scope-video-remote unity-scope-virtualbox unity-scope-yelp unity-scope-zotero unity-lens-friends unity-lens-music unity-lens-photos unity-lens-video -y
    sudo apt-get autoremove

    # Add the Spotify repository.
    sudo add-apt-repository "deb http://repository.spotify.com stable non-free" -y
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59

    # Add the BTSync repository.
    sh -c "$(curl -fsSL http://debian.yeasoft.net/add-btsync-repository.sh)"

    # Add the Zeal repositories.
    sudo add-apt-repository ppa:jerzy-kozera/zeal-ppa -y
    sudo add-apt-repository ppa:ubuntu-sdk-team/ppa -y

    # Add the Yorba daily build repository.
    sudo add-apt-repository ppa:yorba/daily-builds

    # Add the Netflix Desktop repository.
    sudo add-apt-repository ppa:pipelight/stable -y

    # Update the repositories.
    sudo apt-get update

    # Required for netflix-desktop.
    sudo apt-get install ttf-mscorefonts-installer -y

    # Flash player
    sudo apt-get install pepperflashplugin-nonfree -y
    sudo update-pepperflashplugin-nonfree --install

    # Dependency for California calendar.
    sudo apt-get install evolution-data-server -y

    # Install some cool apps :D
    # zeal      -- offline documentation
    # sc        -- spreadsheet calculator
    # gpick     -- colorpicker
    # alacarte  -- slingshot (app launcher) customization
    # zathura   -- keyboard-driven pdf viewer
    sudo apt-get install --no-install-recommends --yes chromium-browser deluge vlc blender gimp inkscape spotify-client btsync-gui netflix-desktop zeal gpick geary california silversearcher-ag zathura

    # scim, a modern version of sc (spreadsheet calculator)
    cd /tmp
    git clone git@github.com:andmarti1424/scim.git
    cd scim/src
    make && sudo make install
    cd $DIR

    # TrueCrypt 7.1a.
    cd /tmp
    wget https://github.com/AuditProject/truecrypt-verified-mirror/blob/master/Linux/truecrypt-7.1a-linux-x64.tar.gz?raw=true
    tar xvzf truecrypt*
    ./truecrypt-7.1a-setup-x64
    cd $DIR

    # Conky
    #sudo apt-get install --no-install-recommends conky-all -y
    #sudo ln -s $DIR/dots/conky ~/.conky
    #sudo ln -s ~/.conky/conkyrc ~/.conkyrc
    #sudo ln -s ~/.conky/conky.desktop ~/.config/autostart/conky.desktop

    # HFS+ file system support.
    # You can re-mount the HFS+ drives with writable access:
    # sudo mount -t hfsplus -o remount,force,rw /mount/point
    sudo apt-get install hfsprogs -y
fi
