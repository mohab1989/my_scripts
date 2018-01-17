# Install gcc/g++ & cmake
sudo apt-get install build-essential cmake

# Install clang llvm compilers
clang_version=5.0
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
sudo apt-add-repository "deb http://apt.llvm.org/xenial/llvm-toolchain-xenial-${clang_version} main"
sudo apt-get update
sudo apt-get install clang-${clang_version}

# Create clang and clang++ link
sudo link /usr/bin/clang-${clang_version}  /usr/bin/clang 
sudo link /usr/bin/clang++-${clang_version}  /usr/bin/clang++ 

# To be able to use add-apt-repository you may need to install software-properties-common
sudo apt-get install software-properties-common

# Install python/pip 2/3
sudo apt-get install python-dev python-pip python3-dev python3-pip

sudo pip install --upgrade pip
sudo pip3 install --upgrade pip

# Install gtest and gmock
# Installs the headers at /usr/include/(gtest\gmock)
sudo apt-get install libgtest-dev google-mock

# Check libgtest.a exists already
if [ ! -f /usr/lib/libgtest.a ];then	
	# generate gtest build files
	cd /usr/src/gtest
	sudo mkdir build && cd build && sudo cmake ..
    # build gtest
    sudo make

	# Move gtest libs to /usr/lib
	sudo mv *.a /usr/lib
	cd .. && sudo rm build -rf
fi

# Check libgmock.a exists already
if [ ! -f /usr/lib/libgmock.a ];then 	
	# generate gmock build files
	cd /usr/src/gmock
	sudo mkdir build && cd build && sudo cmake ..
    
    # build gmock
    sudo make

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

# Install cpplint to check for gogle tyle guide
sudo pip3 install cpplint --user 
sudo pip2 install cpplint --user 

# Install doxygen
#git clone https://github.com/doxygen/doxygen.git
#mkdir build_linux
#cd build_linux
#cmake -G "Unix Makefiles" ..
#make
#sudo make install
