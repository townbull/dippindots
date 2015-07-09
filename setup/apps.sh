OS=$1
DIR=$2

tput setaf 5
echo -e "\nInstalling some more goodies..."
tput sgr0
if [ $OS = 'debian' ]; then
    # Note: Some of this is tailored for my Xubuntu C720 laptop, beware!

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
    sudo apt-get install --no-install-recommends --yes chromium-browser deluge pidgin vlc blender gimp inkscape spotify-client btsync-gui netflix-desktop zeal gpick geary california silversearcher-ag zathura

    # scim, a modern version of sc (spreadsheet calculator)
    cd /tmp
    git clone git@github.com:andmarti1424/scim.git
    cd scim/src
    make && sudo make install
    cd $DIR

    # And remove others.
    sudo apt-get purge gnome-mines gnome-sudoku simple-scan transmission-gtk parole gmusicbrowser printer-driver-foo3zjs-common xfburn gnumeric abiword thunderbird orage -y

    # Was having issues with Light Locker when it comes to suspending the Acer C720, so removing it.
    sudo apt-get purge light-locker light-locker-settings -y

    # TrueCrypt 7.1a.
    cd /tmp
    wget https://github.com/AuditProject/truecrypt-verified-mirror/blob/master/Linux/truecrypt-7.1a-linux-x64.tar.gz?raw=true
    tar xvzf truecrypt*
    ./truecrypt-7.1a-setup-x64
    cd $DIR

    # Conky
    sudo apt-get install --no-install-recommends conky-all -y
    sudo ln -s $DIR/dots/conky ~/.conky
    sudo ln -s ~/.conky/conkyrc ~/.conkyrc
    sudo ln -s ~/.conky/conky.desktop ~/.config/autostart/conky.desktop

    # HFS+ file system support.
    # You can re-mount the HFS+ drives with writable access:
    # sudo mount -t hfsplus -o remount,force,rw /mount/point
    sudo apt-get install hfsprogs -y

    # Show hidden applications in System Settings > Startup Applications.
    sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop

    # Disable bluetooth and hide the menubar icon.
    sudo rfkill block bluetooth
    mkdir ~/.config/autostart
    cp /etc/xdg/autostart/blueman.desktop ~/.config/autostart
    echo "Hidden=true" | tee -a ~/.config/autostart/blueman.desktop
fi
