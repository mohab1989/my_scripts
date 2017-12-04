# Install gcc/g++ & cmake
sudo apt-get install build-essential cmake

# Install clang llvm compilers
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
sudo apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main"
sudo apt-get update
sudo apt-get -y clang-5.0

# To be able to use add-apt-repository you may need to install software-properties-common
sudo apt-get install software-properties-common

# Install python/pip 2/3
sudo apt-get install python-dev python-pip python3-dev python3-pip

sudo -H pip install --upgrade pip
sudo -H pip3 install --upgrade pip
