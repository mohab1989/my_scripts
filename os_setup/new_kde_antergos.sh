#!/bin/bash/

########## Make terminal case insensitive ##########
# If ~./inputrc doesn't exist yet, first include to original /etc/inputrc so we don't override it
if [ ! -f ~/.inputrc ]; then echo '$include /etc/inputrc' > ~/.inputrc; fi

# Add option to ~/.inputrc to enable case-insensitive tab completion
echo 'set completion-ignore-case On' >> ~/.inputrc

########## Install dev tools ##########
sudo pacman -S clang
sudo pacman -S openmp 

sudo pacman python2-pip python-pip

pip3 install sympy --user 

sudo pacman -S gtest gmock

# Check libgtest.a exists already
if [ ! -f /usr/lib/libgtest.a ];then	
	# generate gtest build files
	cd /usr/src/gtest
	sudo mkdir build && cd build && sudo cmake ..
    # build gtest
    sudo make -j

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
    sudo make -j

	# Move gmock libs to /usr/lib
	sudo mv *.a /usr/lib
	cd .. && sudo rm build -rf
fi

# Install cpplint to check for google style guide
pip2 install cpplint --user  
pip3 install cpplint --user  

# Install doxygen
if [ ! -f /usr/local/bin/doxygen ]
then
    if [ ! -d ./doxygen ]
    then
        git clone https://github.com/doxygen/doxygen.git
    fi
cd doxygen
mkdir build_linux
cd build_linux
cmake -G "Unix Makefiles" ..
make -j
sudo make install
#check return code to see if installation were successfull
    if [ $? == 0 ]
    then 
        echo 'Doxygen installation successful'
        echo 'removing downloaded data'
        cd ../..
        rm ./doxygen -rf
    else
        echo 'Doxygen installation failed'
        echo 'keep downloaded data'
    fi  
fi

########## Install important programs ##########
sudo pacman -S partitionmanager
yaourt -S skypeforlinux-stable-bin
yaourt -S teamviewer   
sudo teamviewer --daemon enable

