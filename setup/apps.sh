OS=$1
DIR=$2

tput setaf 5
echo -e "\nInstalling some more goodies..."
tput sgr0
if [ $OS = 'debian' ]; then
    # Note: Some of this is tailored for my Lubuntu 14.04 (HugeGreenBug's distro) C720 laptop, beware!

    # urxvt - terminal
    # i3 - window manager
    # feh - image viewer/wallpaper manager
    # dmenu - application launcher
    # cmus - music player
    # xsel - clipboard
    sudo apt-get update
    sudo apt-get install rxvt-unicode-256color i3 openssh-server lightdm-webkit-greeter feh xsel dmenu cmus wget curl -y
    sudo apt-get install fonts-inconsolata xfonts-terminus -y

    # fim/fimgs - terminal image/pdf viewer
    # http://www.nongnu.org/fbi-improved/
    sudo apt-get install libjpeg-dev libexif-dev
    wget http://download.savannah.nongnu.org/releases/fbi-improved/fim-0.5-trunk.tar.gz -O /tmp/fim.tar.gz
    tar -xzf /tmp/fim.tar.gz
    cd /tmp/fim
    ./configure
    make
    sudo make install
    cd $DIR

    # urxvt perls
    git clone https://github.com/muennich/urxvt-perls.git /tmp/urxvt-perls
    sudo mv /tmp/urxvt-perls/* /usr/lib/urxvt/perl/

    # ranger - file browser
    # Note: For raster image previews (NOT ascii previews) with w3m-image to work,
    # you have to use xterm or urxvt
    sudo apt-get install ranger highlight atool caca-utils w3m w3m-img poppler-utils -y

    # For controlling the screen brightness
    sudo apt-get xbacklight -y

    # Remove openbox window manager
    sudo apt-get autoremove openbox -y

    # Wallpaper
    sudo ln -sf $DIR/assets/background.png /usr/share/lubuntu/wallpapers/lubuntu-default-wallpaper.png

    # User profile pic
    sudo ln -sf $DIR/assets/face.png ~/.face

    # LightDM greeter
    sudo git clone https://github.com/omgmog/lightdm-webkit-google.git /usr/share/lightdm-webkit/themes/lightdm-webkit-google
    sudo ln -sf $DIR/assets/background.jpg /usr/share/lightdm-webkit/themes/lightdm-webkit-google/assets/ui/wallpaper.jpg
    sudo chmod 644 /usr/share/lightdm-webkit/themes/lightdm-webkit-google/assets/ui/wallpaper.jpg
    sudo ln -sf $DIR/dots/ubuntu/lightdm-webkit-greeter.conf /etc/lightdm/lightdm-webkit-greeter.conf

    # Ranger
    ranger --copy-config=scope
    mkdir ~/.config/ranger/colorschemes
    ln -sf $DIR/dots/ranger/euphrasia.py ~/.config/ranger/colorschemes/euphrasia.py
    ln -sf $DIR/dots/ranger/rc.conf ~/.config/ranger/rc.conf

    # LightDM config
    sudo ln -sf $DIR/dots/ubuntu/lightdm.conf /etc/lightdm/lightdm.conf.d/20-lubuntu.conf

    # lxappearance for managing GTK themeing
    sudo apt-get install lxappearance -y
    sudo git clone https://github.com/aceat64/Numix-Blue.git /usr/share/themes/Numix-Blue
    git clone https://github.com/daniruiz/Super-Flat-Remix.git /tmp/Super-Flat-Remix
    sudo mv "/tmp/Super-Flat-Remix/Super Flat Remix" /usr/share/icons/
    ln $DIR/dots/ubuntu/gtkrc-2.0 ~/.gtkrc-2.0

    # Dunst (notifications) config
    mkdir ~/.config/dunst
    ln -sf $DIR/dots/ubuntu/dunstrc ~/.config/dunst/dunstrc

    # Setup C720's function keys
    ln -sf $DIR/dots/ubuntu/xmodmaprc ~/.xmodmaprc

    # Other defaults
    ln $DIR/dots/ubuntu/autostart ~/.config/lxsession/Lubuntu/autostart
    ln $DIR/dots/ubuntu/desktop.conf ~/.config/lxsession/Lubuntu/desktop.conf
    ln $DIR/dots/ubuntu/Xresources ~/.Xresources

    # Hide cursor after inactivity
    sudo apt-get install unclutter -y

    # Conky (for the i3bar)
    sudo apt-get install --no-install-recommends conky-all -y

    # i3 configs
    ln $DIR/dots/i3 ~/.i3

    # Remove unwanted stuff
    sudo apt-get purge mtpaint pidgin xchat* sylpheed* abiword* gnumeric* transmission* audacious* -y
    sudo apt-get autoremove
    rm -rf ~/.sylpheed*

    # Add the Spotify repository.
    sudo add-apt-repository "deb http://repository.spotify.com stable non-free" -y
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59

    # Add the BTSync repository.
    sh -c "$(curl -fsSL http://debian.yeasoft.net/add-btsync-repository.sh)"

    # Add the Zeal repositories.
    sudo add-apt-repository ppa:jerzy-kozera/zeal-ppa -y
    sudo add-apt-repository ppa:ubuntu-sdk-team/ppa -y

    # Add the yorba/vala daily build repositories.
    sudo add-apt-repository ppa:yorba/daily-builds
    sudo add-apt-repository ppa:vala-team/ppa

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
    sudo apt-get install --no-install-recommends --yes chromium-browser deluge vlc gimp inkscape spotify-client btsync-gui netflix-desktop zeal gpick geary california silversearcher-ag zathura

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

    # HFS+ file system support.
    # You can re-mount the HFS+ drives with writable access:
    # sudo mount -t hfsplus -o remount,force,rw /mount/point
    sudo apt-get install hfsprogs -y
fi
