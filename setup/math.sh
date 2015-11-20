OS=$1

if [ $OS = 'osx' ]; then
    brew install openblas

elif [ $OS = 'debian' ]; then
    sudo apt-get install libatlas-base-dev liblapack-dev libopenblas-dev libopenblas-base libatlas3gf-base -y
fi
