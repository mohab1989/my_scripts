#!/bin/bash
os=$(bash get_linux_distro.sh)
echo "Linux Distro: $os"

echo "Installing Fish..."
if [ "$os" == "Antergos Linux" ]
then
    echo "Antergos: using pacman"
    sudo pacman -S fish
else
    echo "not Antergos"
    sudo apt-get install fish
fi

fish_path=$(which fish) 

config_file_dir=~/.config/fish/
config_file_name=config.fish
config_file=$config_file_dir$config_file_name

if [ ! -f update_aliases.sh ]
then
	wget https://raw.githubusercontent.com/mohab1989/my_scripts/master/update_aliases.sh 
fi

source update_aliases.sh o

if [ ! -f $config_file ]; then

    echo "Createing config file '$config_file'..."
	mkdir -p $config_file_dir
	echo "
# Change fish greeting message to empty string
set -g -x fish_greeting ''

# Make fish use 256 colors  
set fish_term256 1

# Setup aliases for frequently used commands
source ~/.alias" >> $config_file

else
	echo "Found existing config '$config_file'"
fi

if [ ! $SHELL = $fish_path ];then
	echo "Changing default shell to fish"
	chsh -s $fish_path
	echo "Please logout and in again for changes to take effect"
else
	echo "Fish is already default shell"
fi 
