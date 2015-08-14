OS=$1
DIR=$2

tput setaf 5
echo -e "\nInstalling utilties..."
tput sgr0
if [ $OS = 'osx' ]; then
    # Install Bash 4
    brew install bash

    # Install wget with IRI support
    brew install wget --enable-iri
    brew install httpie

    brew install tree
    brew install nmap
    brew install gpg
    brew install dos2unix
    brew install git
    brew install jq
    brew install pandoc
    brew install imagemagick
    brew install htop
    brew install fasd
    brew install ffmpeg --with-fdk-aac --with-ffplay --with-freetype --with-frei0r --with-libass --with-libvo-aacenc --with-libvorbis --with-libvpx --with-opencore-amr --with-openjpeg --with-opus --with-rtmpdump --with-schroedinger --with-speex --with-theora --with-tools

    # https://github.com/Homebrew/homebrew/issues/24132
    brew install libtorrent --build-from-source
    brew install rtorrent

    # tmux (with vim copy paste support)
    brew install tmux
    brew install reattach-to-user-namespace --wrap-pbcopy-pbpaste && brew link reattach-to-user-namespace

    # Requires that you do:
    # export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt
    brew install curl-ca-bundle

    # Fast searching with The Silver Searcher (ag)
    brew install the_silver_searcher

elif [ $OS = 'debian' ]; then
    sudo add-apt-repository ppa:jon-severinsson/ffmpeg -y
    sudo apt-get update

    sudo apt-get install --no-install-recommends dos2unix tmux curl jq gpg htop wget dnsutils imagemagick nmap httpie silversearcher-ag fasd rtorrent -y

    # ffmpeg
    sudo apt-get -y --force-yes install autoconf automake build-essential libass-dev libfreetype6-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texi2html zlib1g-dev libx264-dev libmp3lame-dev libfdk-aac-dev libvpx-dev libopus-dev yasm
    git clone --depth=1 git://source.ffmpeg.org/ffmpeg.git /tmp/ffmpeg
    cd /tmp/ffmpeg
    ./configure --enable-gpl --enable-libass --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-nonfree
    make
    sudo make install
    cd $DIR

fi

# rtorrent setup
mkdir ~/.watch
mkdir ~/.session
ln -s $DIR/dots/rtorrent/rtorrent.rc ~/.rtorrent.rc
