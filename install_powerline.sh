sudo apt-get install python-pip git
sudo pip install setuptools
pip install --user git+git://github.com/Lokaltog/powerline

if grep -q PATH=\"\$HOME/.local/bin:\$PATH\" ~/.profile; then
    echo "'$HOME/.local/bin' already exists in ~/.profile PATH"
    else
    echo "
	if [ -d \"\$HOME/.local/bin\" ]; then
    	PATH=\"\$HOME/.local/bin:\$PATH\"
	fi" \ 
>> ~/.profile
fi



source ~/.profile