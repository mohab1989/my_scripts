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

# Install gtest and gmock
# Installs the headers at /usr/include/(gtest\gmock)
sudo apt-get install libgtest-dev google-mock

# Check libgtest.a exists already
if [ ! -f /usr/lib/libgtest.a ];then
	
	# build gtest
	cd /usr/src/gtest
	mkdir build && cd build && cmake ..

	# Move gtest libs to /usr/lib
	sudo mv *.a /usr/lib
	cd .. && sudo rm build -rf
fi

# Check libgmock.a exists already
if [ ! -f /usr/lib/libgmock.a ];then 
	
	# build gmock
	cd /usr/src/gmock
	mkdir build && cd build && cmake ..

	# Move gmock libs to /usr/lib
	sudo mv *.a /usr/lib
	cd .. && sudo rm build -rf
fi

# Installing TeXLive Latex viewer
#wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
#tar -xzf install-tl-unx.tar.gz
#rm install-tl-unx.tar.gz 
#cd install-tl-20180106/
#sudo ./install-tl
