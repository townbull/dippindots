OS=$1
DIR=$2

if [ $OS = 'osx' ]; then
    # Install stuff for Freenode SASL
    #for i in 'Crypt::OpenSSL::Bignum' 'Crypt::DH' 'Crypt::Blowfish' 'Math::BigInt' ; do sudo perl -MCPAN -e shell <<< "install $i" ; done

    brew install weechat --with-python --with-perl
    brew install bitlbee

    # Setup ca-certificates for OSX.
    wget http://curl.haxx.se/download/curl-7.38.0.tar.gz -O /tmp/curl.tgz
    cd /tmp
    tar -xzvf curl.tgz
    cd curl-*/lib
    ./mk-ca-bundle.pl
    sudo mkdir -p /etc/ssl/certs/
    sudo mv ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
    cd $DIR
fi

# Also, rainbowstream for twitter
sudo pip install rainbowstream

sudo ln -s $DIR/dots/weechat ~/.weechat
sudo ln -sf $DIR/dots/rainbow_config.json ~/.rainbow_config.json
