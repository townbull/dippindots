OS=$1
DIR=$2

tput setaf 5
echo -e "\nInstalling some more goodies..."
tput sgr0
if [ $OS = 'debian' ]; then
    # Note: Some of this is tailored for my Lubuntu 14.04 (HugeGreenBug's distro) C720 laptop, beware!

    # urxvt - terminal
    # feh - image viewer/wallpaper manager
    # dmenu - application launcher
    # cmus - music player
    # xsel - clipboard
    # xdotool - simulating interactions with the GUI
    # compton - shadows
    # slock - locking the screen
    # libnotify-bin - for `notify-send` to create notifications
    sudo apt-get update
    sudo apt-get install rxvt-unicode-256color openssh-server lightdm-webkit-greeter feh xsel dmenu cmus wget curl xdotool compton slock -y
    sudo apt-get install fonts-inconsolata xfonts-terminus -y

    # Setup fonts
    ln -sf $DIR/assets/fonts ~/.fonts

    # siji is preloaded in the fonts folder
    #git clone https://github.com/gstk/siji /tmp/siji
    #cp /tmp/siji/siji.pcf ~/.fonts/

    mkfontdir ~/.fonts
    mkfontscale ~/.fonts
    xset +fp ~/.fonts/
    xset fp rehash
    fc-cache
    fc-cache -fv

    # nmcli_dmenu for managing network connections via dmenu
    # the lubuntu image I'm using for my C720 has networkmanager 0.9.8.8 so we used an older version of nmcli_dmenu.
    # git clone -b networkmanager-0.9.8 https://github.com/firecat53/nmcli-dmenu /tmp/nmcli-dmenu
    # sudo mv /tmp/nmcli-dmenu/nmcli-dmenu /usr/bin/
    # No need to install b/c a copy is symlinked to in $DIR/bin/

    # bspwm - window manager
    sudo apt-get install xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev -y
    git clone https://github.com/baskerville/bspwm.git /tmp/bspwm
    git clone https://github.com/baskerville/sxhkd.git /tmp/sxhkd
    cd /tmp/bspwm && make && sudo make install
    cd /tmp/sxhkd && make && sudo make install
    cd $DIR

    # bspwm config
    ln -sf $DIR/dots/bspwm  ~/.config/bspwm
    ln -sf $DIR/dots/sxhkd  ~/.config/sxhkd
    ln -sf ~/.config/bspwm/panel/panel /usr/bin/panel
    ln -sf ~/.config/bspwm/panel/panel_bar /usr/bin/panel_bar

    # bspwm lightdm stuff
    sudo cp /tmp/bspwm/contrib/freedesktop/bspwm-session /usr/bin/
    sudo cp /tmp/bspwm/contrib/freedesktop/bspwm.desktop /usr/bin/xsessions/

    # bspwm-related goodies
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

    # xinitrc (not used by lightdm, but here for reference)
    ln -sf $DIR/dots/ubuntu/xinitrc ~/.xinitrc

    # Wallpapers
    ln -sf $DIR/assets/wallpapers ~/.wallpapers
    ln -sf ~/.wallpapers/0.jpg ~/.wallpaper.jpg
    chmod 644 ~/.wallpaper.jpg

    # User profile pic
    ln -sf $DIR/assets/face.png ~/.face

    # LightDM greeter
    sudo git clone https://github.com/omgmog/lightdm-webkit-google.git /usr/share/lightdm-webkit/themes/lightdm-webkit-google
    sudo ln -sf ~/.wallpaper.jpg /usr/share/lightdm-webkit/themes/lightdm-webkit-google/assets/ui/wallpaper.jpg
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
    ln -sf $DIR/dots/dunst  ~/.config/dunst

    # Setup C720's function keys
    ln -sf $DIR/dots/ubuntu/xmodmaprc ~/.xmodmaprc

    # Other defaults
    ln -sf $DIR/dots/ubuntu/desktop.conf ~/.config/lxsession/Lubuntu/desktop.conf
    ln -sf $DIR/dots/ubuntu/Xresources ~/.Xresources
    ln -sf $DIR/dots/ubuntu/xsessionrc ~/.xsessionrc

    # Hide cursor after inactivity
    sudo apt-get install unclutter -y

    # Conky (for the lemonbar)
    sudo apt-get install --no-install-recommends conky-all -y

    # Remove unwanted stuff (Lubuntu 14.04)
    sudo apt-get purge mtpaint pidgin xchat* sylpheed* abiword* gnumeric* transmission* audacious* -y
    sudo apt-get autoremove -y
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
    # zathura   -- keyboard-driven pdf viewer
    sudo apt-get install --no-install-recommends --yes chromium-browser deluge vlc gimp inkscape spotify-client btsync-gui netflix-desktop zeal gpick geary california silversearcher-ag zathura

    # zathura config
    ln -sf $DIR/dots/zathura ~/.config/zathura

    # scim, a modern version of sc (spreadsheet calculator)
    cd /tmp
    git clone https://github.com/andmarti1424/scim.git
    cd scim/src
    make && sudo make install
    cd $DIR

    # Scudcloud (Slack)
    sudo apt-add-repository -y ppa:rael-gc/scudcloud
    sudo apt-get update
    sudo apt-get install scudcloud -y

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


# Symlink notes and sites
ln -sf $DIR/dots/config/nomadic ~/.nomadic
ln -sf $DIR/dots/port ~/.port
