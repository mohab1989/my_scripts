#############################################################
# Variables
#############################################################
shells=$(echo "$1" | tr '[:upper:]' '[:lower:]')
python_version=$2
echo "using python_version $2"
fish_config_file=~/.config/fish/config.fish
bash_config_file=~/.bashrc
#############################################################
# Installing pip and powerline per user
#############################################################
sudo apt-get install python$python_version
sudo apt-get install python$python_version-pip git
sudo -H pip$python_version install --upgrade pip
sudo -H pip$python_version install setuptools
echo "Installing powerline..."
if pip$python_version list --format=legacy | grep  powerline; then
	echo "powerline found."
else
	sudo pip$python_version install --user git+git://github.com/powerline/powerline
fi
#############################################################
# Adding to Path
#############################################################
echo "Adding '$HOME/.local/bin' to PATH in ~/.profile"
if grep -q PATH=\"\$HOME/.local/bin:\$PATH\" ~/.profile; then
    echo "'$HOME/.local/bin' already exists in ~/.profile PATH"
else
    echo "
if [ -d \"\$HOME/.local/bin\" ]; then
	PATH=\"\$HOME/.local/bin:\$PATH\"
fi">> ~/.profile
fi

#############################################################
# Font Installation
#############################################################
if [ ! -f ~/.fonts/PowerlineSymbols.otf ]; then
	wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
	mkdir -p ~/.fonts/ && mv PowerlineSymbols.otf ~/.fonts/
else
	echo "'~/.fonts/PowerlineSymbols.otf' found."
fi
fc-cache -vf ~/.fonts

if [ ! -f ~/.config/fontconfig/conf.d/10-powerline-symbols.conf ]; then
	mkdir -p ~/.config/fontconfig/conf.d/ && mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
else
	echo "'~/.config/fontconfig/conf.d/10-powerline-symbols.conf' found."
fi

#############################################################
# Adding powerline scripts to config files
# (vim,bash,zsh,fish,tmux)
#############################################################
repository_root=$(pip$python_version show powerline-status | grep -i 'Location' | cut -d' ' -f2)
echo "repository_root: $repository_root"
# 1) Fish:
if echo $shells | grep -q fish ; then
	if [ -f $fish_config_file ]; then
		if [ ! -f ./install_fish.sh ]; then
			wget https://raw.githubusercontent.com/mohab1989/my_scripts/master/install_fish.sh
		fi
		echo "Running install_fish.sh"
		source ./install_fish.sh
	fi
	if grep -q powerline-setup $fish_config_file; then
		echo "fish powerline binding already added to $fish_config_file"
	else
		echo "Adding powerline binding script inside $fish_config_file"
		echo "
# Bind fish with powerline and run powerline
set fish_function_path \$fish_function_path \"$repository_root/powerline/bindings/fish\"
powerline-setup" >> $fish_config_file 
	fi
fi

# 2) Bash:
if echo $shells | grep -q bash ; then
	if grep -q powerline $bash_config_file; then
		echo "bash powerline binding already added to $bash_config_file"
	else
		echo "Adding powerline binding script inside $bash_config_file"
		echo "
		source $repository_root/powerline/bindings/bash/powerline.sh" >> $bash_config_file 
	fi
fi

echo "Log out and in again for changes to take effect."
