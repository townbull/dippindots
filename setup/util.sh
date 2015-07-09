OS=$1

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
    brew insstall jq
    brew install pandoc
    brew install ffmpeg --with-fdk-aac --with-ffplay --with-freetype --with-frei0r --with-libass --with-libvo-aacenc --with-libvorbis --with-libvpx --with-opencore-amr --with-openjpeg --with-opus --with-rtmpdump --with-schroedinger --with-speex --with-theora --with-tools

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

    sudo apt-get install --no-install-recommends dos2unix ffmpeg tmux curl jq gpg wget dnsutils httpie silversearcher-ag -y
fi
