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
    # xdotool - simulating interactions with the GUI
    # compton - shadows
    # slock - locking the screen
    # libnotify-bin - for `notify-send` to create notifications
    # unclutter - hide cursor after inactivity
    # xbacklight - control screen brightness
    # hfsprogs - hfs+ file system support
    # gdebi - easier installation of deb packages
    # dhcpcd - for android usb tethering
    sudo apt-get update
    sudo apt-get install xorg --no-install-recommends -y
    sudo apt-get install feh xsel dmenu xdotool compton conky slock libnotify-bin unclutter xbacklight hfsprogs rtorrent gdebi dhcpcd -y

    # mpd/ncmpcpp/mpc - music player
    sudo apt-get install mpd mpc -y

    # build the latest ncmpcpp
    sudo apt-get install libboost-all-dev libfftw3-dev doxygen libncursesw5-dev libtag1-dev libcurl4-openssl-dev
    git clone --depth=1 git://git.musicpd.org/master/libmpdclient.git /tmp/libmpdclient
    cd /tmp/libmpdclient
    ./autogen.sh
    make
    sudo make install
    git clone --depth=1 git://repo.or.cz/ncmpcpp.git /tmp/ncmpcpp
    cd /tmp/ncmpcpp
    ./autogen.sh
    autoreconf --force --install
    BOOST_LIB_SUFFIX="" ./configure --enable-visualizer --enable-outputs --enable-clock --enable-unicode --with-taglib --with-fftw --with-curl
    make
    sudo make install
    cd $DIR

    # build latest libass for ffmpeg and mpv
    sudo apt-get install libfribidi-dev
    git clone --depth=1 https://github.com/libass/libass.git /tmp/libass
    cd /tmp/libass
    ./autogen.sh
    ./configure
    make
    sudo make install

    # ffmpeg
    sudo apt-get -y --force-yes install autoconf automake build-essential libfreetype6-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texi2html zlib1g-dev libx264-dev libmp3lame-dev libfdk-aac-dev libvpx-dev libopus-dev yasm
    git clone --depth=1 git://source.ffmpeg.org/ffmpeg.git /tmp/ffmpeg
    cd /tmp/ffmpeg

    # a detour for x265
    sudo apt-get install cmake
    wget https://bitbucket.org/multicoreware/x265/downloads/x265_1.7.tar.gz -O /tmp/ffmpeg/x265.tar.gz
    cd /tmp/ffmpeg
    tar -xzvf x265.tar.gz
    cd x265_*/build/linux
    PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
    make
    sudo make install

    # compile ffmpeg
    PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
      --prefix="$HOME/ffmpeg_build" \
      --pkg-config-flags="--static" \
      --extra-cflags="-I$HOME/ffmpeg_build/include" \
      --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
      --bindir="/usr/local/bin" \
      --enable-gpl \
      --enable-libass \
      --enable-libfdk-aac \
      --enable-libfreetype \
      --enable-libmp3lame \
      --enable-libopus \
      --enable-libtheora \
      --enable-libvorbis \
      --enable-libvpx \
      --enable-libx264 \
      --enable-libx265 \
      --enable-nonfree \
      --enable-openssl
    make
    sudo make install
    rm -rf ~/ffmpeg_build
    cd $DIR

    # build the latest mpv
    # this requires ffmpeg!
    git clone --depth=1 https://github.com/mpv-player/mpv.git /tmp/mpv
    cd /tmp/mpv
    ./bootstrap.py
    ./waf configure
    ./waf build
    sudo ./waf install
    cd $DIR

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

    # Other defaults
    ln -sf $DIR/dots/ubuntu/xinitrc ~/.xinitrc
    ln -sf $DIR/dots/ubuntu/Xresources ~/.Xresources
    ln -sf $DIR/dots/ubuntu/colors ~/.colors

    # Syncthing
    curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
    echo deb http://apt.syncthing.net/ syncthing release | sudo tee /etc/apt/sources.list.d/syncthing-release.list

    # Scudcloud (Slack client)
    sudo apt-add-repository -y ppa:rael-gc/scudcloud

    # Latest Chromium
    sudo add-apt-repository ppa:canonical-chromium-builds/stage

    # Update the repositories
    sudo apt-get update

    # Flash player
    sudo apt-get install pepperflashplugin-nonfree -y
    sudo update-pepperflashplugin-nonfree --install

    # Install some cool apps :D
    # sc            -- spreadsheet calculator
    # gpick         -- colorpicker
    # zathura       -- keyboard-driven pdf viewer
    # scudcloud     -- slack
    # ncdu          -- ncurses disk usage
    # keepassx      -- password management
    sudo apt-get install --no-install-recommends --yes chromium-browser gpick silversearcher-ag zathura syncthing android-tools-adb openvpn scudcloud ncdu keepassx

    # chromium for netflix
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
    sudo gdebi /tmp/chrome.deb

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
    git clone https://github.com/horst3180/arc-theme --depth 1 /tmp/arc
    cd /tmp/arc
    ./autogen.sh --prefix=/usr
    git clone https://github.com/daniruiz/Super-Flat-Remix.git /tmp/Super-Flat-Remix
    sudo mv "/tmp/Super-Flat-Remix/Super Flat Remix" /usr/share/icons/
    ln $DIR/dots/ubuntu/gtkrc-2.0 ~/.gtkrc-2.0

    # Setup fonts
    # (necessary to allow bitmap fonts)
    sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
    sudo ln -s /etc/fonts/conf.avail/70-yes-bitmaps.conf /etc/fonts/conf.d/70-yes-bitmaps.conf
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

    # For easily updating system time to current time zone
    # To preview, run `tzupdate -p`
    # To make the change, run `sudo tzupdate`
    # TO DO update this to proper repo after PR is accepted
    sudo pip2 install https://github.com/ftzeng/tzupdate/archive/develop.zip

    # Power management stuff
    # Note:
    # /etc/systemd/logind.conf
    #   HandleLidSwitch=suspend
    #   HandlePowerKey=ignore

    # This was necessary to get sound and video working on the C720 (sound and video was only playable by root)
    sudo adduser ftseng audio
    sudo adduser ftseng pulse-access
    sudo adduser ftseng video

    # Firefox config
    # still deciding b/w firefox and chromium
    mkdir -p ~/.mozilla/firefox/profile.default/chrome
    ln -sf $DIR/dots/firefox/userChrome.css ~/.mozilla/firefox/profile.default/chrome/userChrome.css

    # Change default browser
    sudo update-alternatives --config x-www-browser
    sudo update-alternatives --config gnome-www-browser

    # xrectsel for region selection (for recording regions)
    git clone https://github.com/lolilolicon/xrectsel.git /tmp/xrectsel
    cd /tmp/xrectsel
    ./bootstrap
    ./configure --prefix /usr
    make
    sudo make install
    cd $DIR

    # for screen recordings
    sudo apt-get install imagemagick recordmydesktop gifsicle

    # Remove unwanted stuff (Lubuntu 14.04)
    # Run this last as it will remove `network-manager` and we'll lose the internet connection
    rm -rf ~/.sylpheed*
    sudo apt-get purge mtpaint pidgin xchat* sylpheed* abiword* gnumeric* transmission* audacious* lightdm openbox network-manager -y
    sudo apt-get autoremove -y

elif [ $OS = 'osx' ]; then
    brew install mpd mpc ncmpcpp syncthing

    # https://github.com/Homebrew/homebrew/issues/24132
    brew install libtorrent --build-from-source
    brew install rtorrent
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

# rtorrent setup
mkdir ~/.watch
mkdir ~/.session
ln -s $DIR/dots/rtorrent/rtorrent.rc ~/.rtorrent.rc

# backup config
ln -s $DIR/dots/bkup ~/.bkup
