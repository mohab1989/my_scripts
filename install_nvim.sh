#!/bin/bash
pip_version=$1
if [ $pip_version -eq "3" ];then
    python_version="python3"
else
    python_version="python2"
fi

vim_plug_directory=~/.local/share/nvim/site/autoload/
plugins_directory=~/.local/share/nvim/plugged
global_ycm_extra_conf=$plugins_directory'/YouCompleteMe/.ycm_extra_conf.py'
plug_vim_file=$vim_plug_directory'plug.vim'

# Make directory for neovim config file init.vim (.vimrc)
nvim_config_dir=~/.config/nvim/
nvim_config_file=$nvim_config_dir'init.vim'

if [ ! -f install_essentials.sh ];then
    echo "Get install install_essentials.sh"
    wget https://raw.githubusercontent.com/mohab1989/my_scripts/master/install-essentials.sh
fi

# Installng essentials like python and pip
source ./install_essentials.sh

# Add neovim repo to apt package manager
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update

# Installing neovim with apt
echo "Install nvim with $python_version support"
sudo apt-get install neovim

# Installing neovim python client
sudo -H pip$pip_version install neovim

# Install xclip to allow for copy cut and paste in nvim using os clipboard
sudo apt-get install xclip

# Install nerd fonts so that vim-devicon can find them 
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf

# Make directory for init.vim 
mkdir -p $nvim_config_dir

# Installing vim-plug
if [ ! -f $plug_vim_file ]; then
	echo "Downloading plug.vim..."
    curl -fLo $plug_vim_file --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
	echo "plug.vim already installed"
fi

# adding plugins to init .vim
if grep -q "call plug#begin" $nvim_config_file;then
	echo "plug begin already added to init.vim overwriting existing init.Vim"
# OverWrite previous init.vim
	source update_init.vim.sh o --python $python_version
else
	echo "adding plugins to to neovim"
# appending to existing file or making a new one 
	source update_init.vim.sh --python $python_version
fi

# Run PlugInstall to install all plugins
nvim +PlugInstall

if [ ! -f $global_ycm_extra_conf ];then
	echo "Get global_ycm_extra_conf"
	curl -fLo $global_ycm_extra_conf \
	https://raw.githubusercontent.com/mohab1989/my_scripts/master/dot_files/.ycm_extra_conf.py
else
	echo "global_ycm_extra_conf already exists"
fi
