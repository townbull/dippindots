OS=$1
DIR=$2

tput setaf 5
echo -e "\nInstalling some more goodies..."
tput sgr0
if [ $OS = 'debian' ]; then
    # Note: Some of this is tailored for my Lubuntu 14.04 (HugeGreenBug's distro) C720 laptop, beware!

    # feh - image viewer/wallpaper manager
    # xsel - clipboard
    # dmenu - application launcher
    # mpd/ncmpcpp/mpc - music player
    # xdotool - simulating interactions with the GUI
    # compton - shadows
    # slock - locking the screen
    # libnotify-bin - for `notify-send` to create notifications
    # unclutter - hide cursor after inactivity
    # xbacklight - control screen brightness
    # hfsprogs - hfs+ file system support
    sudo apt-get update
    sudo apt-get install xorg --no-install-recommends -y
    sudo apt-get install feh xsel dmenu mpd mpc ncmpcpp xdotool compton slock libnotify-bin unclutter xbacklight hfsprogs -y

    # bspwm - window manager
    sudo apt-get install xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev -y
    git clone https://github.com/baskerville/bspwm.git /tmp/bspwm
    git clone https://github.com/baskerville/sxhkd.git /tmp/sxhkd
    cd /tmp/bspwm && make && sudo make install
    cd /tmp/sxhkd && make && sudo make install
    cd $DIR
    ln -sf $DIR/dots/bspwm  ~/.config/bspwm
    ln -sf $DIR/dots/sxhkd  ~/.config/sxhkd
    sudo ln -sf ~/.config/bspwm/panel/panel /usr/bin/panel
    sudo ln -sf ~/.config/bspwm/panel/panel_bar /usr/bin/panel_bar

    # lemonbar - status bar/panel
    git clone https://github.com/baskerville/sutils.git /tmp/sutils
    git clone https://github.com/baskerville/xtitle.git /tmp/xtitle
    git clone https://github.com/LemonBoy/bar.git /tmp/bar
    cd /tmp/sutils && make && sudo make install
    cd /tmp/xtitle && make && sudo make install
    cd /tmp/bar && make && sudo make install
    echo 'export PANEL_FIFO="/tmp/panel-fifo"' | sudo tee -a /etc/profile
    cd $DIR

    # fim/fimgs - terminal image/pdf viewer
    # http://www.nongnu.org/fbi-improved/
    sudo apt-get install libjpeg-dev libexif-dev -y
    wget http://download.savannah.nongnu.org/releases/fbi-improved/fim-0.5-trunk.tar.gz -O /tmp/fim.tar.gz
    tar -xzf /tmp/fim.tar.gz
    cd /tmp/fim
    ./configure
    make && sudo make install
    cd $DIR

    # urxvt - terminal
    sudo apt-get install rxvt-unicode-256color -y
    git clone https://github.com/muennich/urxvt-perls.git /tmp/urxvt-perls
    sudo mv /tmp/urxvt-perls/* /usr/lib/urxvt/perl/

    # ranger - file browser
    # Note: For raster image previews (NOT ascii previews) with w3m-image to work,
    # you have to use xterm or urxvt
    sudo apt-get install ranger highlight atool caca-utils w3m w3m-img poppler-utils -y
    ranger --copy-config=scope
    mkdir ~/.config/ranger/colorschemes
    ln -sf $DIR/dots/ranger/euphrasia.py ~/.config/ranger/colorschemes/euphrasia.py
    ln -sf $DIR/dots/ranger/rc.conf ~/.config/ranger/rc.conf

    # wicd - managing network connections
    sudo apt-get install wicd wicd-cli wicd-curses -y
    sudo ln -sf /run/resolvconf/resolv.conf /var/lib/wicd/resolv.conf.orig

    # Dunst (notifications) config
    ln -sf $DIR/dots/dunst  ~/.config/dunst

    # Setup C720's function keys
    ln -sf $DIR/dots/ubuntu/xmodmaprc ~/.xmodmaprc

    # Other defaults
    ln -sf $DIR/dots/ubuntu/xinitrc ~/.xinitrc
    ln -sf $DIR/dots/ubuntu/Xresources ~/.Xresources
    ln -sf $DIR/dots/ubuntu/xsessionrc ~/.xsessionrc

    # Spotify
    sudo add-apt-repository "deb http://repository.spotify.com stable non-free" -y
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59

    # Scudcloud (Slack client)
    sudo apt-add-repository -y ppa:rael-gc/scudcloud

    # BitTorrent Sync
    sh -c "$(curl -fsSL http://debian.yeasoft.net/add-btsync-repository.sh)"

    # Zeal
    sudo add-apt-repository ppa:jerzy-kozera/zeal-ppa -y
    sudo add-apt-repository ppa:ubuntu-sdk-team/ppa -y

    # Geary/California
    sudo add-apt-repository ppa:yorba/daily-builds
    sudo add-apt-repository ppa:vala-team/ppa

    # Netflix Desktop
    sudo add-apt-repository ppa:pipelight/stable -y

    # Update the repositories
    sudo apt-get update

    # Required for netflix-desktop
    sudo apt-get install ttf-mscorefonts-installer -y

    # Flash player
    sudo apt-get install pepperflashplugin-nonfree -y
    sudo update-pepperflashplugin-nonfree --install

    # Required for california
    sudo apt-get install evolution-data-server -y

    # Install some cool apps :D
    # zeal          -- offline documentation
    # sc            -- spreadsheet calculator
    # gpick         -- colorpicker
    # zathura       -- keyboard-driven pdf viewer
    # california    -- calendar
    # geary         -- email
    # scudcloud     -- Slack
    sudo apt-get install --no-install-recommends --yes chromium-browser vlc gimp inkscape spotify-client netflix-desktop zeal gpick geary california silversearcher-ag zathura scudcloud

    # btsync
    # Accessible via localhost:8888 (or whatever you configure)
    # Copy the config so it can have the proper permissions
    sudo apt-get install btsync -y
    sudo ln -sf $DIR/dots/btsync/btsync /etc/default/btsync
    sudo cp $DIR/dots/btsync/main.conf /etc/btsync/main.conf
    sudo chown $USER:$USER /etc/btsync/main.conf
    chmod 600 /etc/btsync/main.conf

    # zathura config
    ln -sf $DIR/dots/zathura ~/.config/zathura

    # scim, a modern version of sc (spreadsheet calculator)
    cd /tmp
    git clone https://github.com/andmarti1424/scim.git
    cd scim/src
    make && sudo make install
    cd $DIR

    # TrueCrypt 7.1a
    cd /tmp
    wget https://github.com/AuditProject/truecrypt-verified-mirror/blob/master/Linux/truecrypt-7.1a-linux-x64.tar.gz?raw=true
    tar xvzf truecrypt*
    ./truecrypt-7.1a-setup-x64
    cd $DIR

    # lxappearance for managing GTK themeing
    sudo apt-get install lxappearance -y
    sudo git clone https://github.com/aceat64/Numix-Blue.git /usr/share/themes/Numix-Blue
    git clone https://github.com/daniruiz/Super-Flat-Remix.git /tmp/Super-Flat-Remix
    sudo mv "/tmp/Super-Flat-Remix/Super Flat Remix" /usr/share/icons/
    ln $DIR/dots/ubuntu/gtkrc-2.0 ~/.gtkrc-2.0

    # Setup fonts
    sudo apt-get install fonts-inconsolata xfonts-terminus -y
    ln -sf $DIR/assets/fonts ~/.fonts
    mkfontdir ~/.fonts
    mkfontscale ~/.fonts
    xset +fp ~/.fonts/
    xset fp rehash
    fc-cache
    fc-cache -fv

    # Wallpapers
    ln -sf $DIR/assets/wallpapers ~/.wallpapers
    ln -sf ~/.wallpapers/0.jpg ~/.wallpaper.jpg
    chmod 644 ~/.wallpaper.jpg

    # User profile pic
    ln -sf $DIR/assets/face.png ~/.face

    # Remove unwanted stuff (Lubuntu 14.04)
    rm -rf ~/.sylpheed*
    sudo apt-get purge mtpaint pidgin xchat* sylpheed* abiword* gnumeric* transmission* audacious* lightdm openbox network-manager -y
    sudo apt-get autoremove -y

    # Power management stuff
    # Note:
    # /etc/systemd/logind.conf
    #   HandleLidSwitch=suspend
    #   HandlePowerKey=ignore
if [ $OS = 'osx' ]; then
    brew install mpd mpc ncmpcpp
fi

# mpd/ncmpcpp configs
mkdir ~/.mpd/
mkdir ~/.mpd/playlists
touch ~/.mpd/{mpd.db,mpd.log,mpd.pid,mpd.state}
ln -sf $DIR/dots/mpd/mpd.conf ~/.mpd/mpd.conf
ln -sf $DIR/dots/ncmpcpp ~/.ncmpcpp

# Symlink notes and sites
ln -sf $DIR/dots/config/nomadic ~/.nomadic
ln -sf $DIR/dots/port ~/.port
