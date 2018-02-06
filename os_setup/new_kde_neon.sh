#### Purge firefox ####
sudo apt purge firefox

#### Install google chrome ####
# Add Key:
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
# Set repository:
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
# install package
sudo apt-get update 
sudo apt-get install google-chrome-stable

#### Install kde partiotion manager ####
sudo apt-get install partitionmanager

#### Install Git ####
sudo apt-get install git-all


#### Make terminal case insensitive ####
# If ~./inputrc doesn't exist yet, first include te original /etc/inputrc so we don't override it
if [ ! -a ~/.inputrc ]; then echo '$include /etc/inputrc' > ~/.inputrc; fi

# Add option to ~/.inputrc to enable case-insensitive tab completion
echo 'set completion-ignore-case On' >> ~/.inputrc

#### get my scripts from git ####
git clone https://github.com/mohab1989/my_scripts.git ~/my_scripts

#### Install Fish ####
cd ~/my_scripts
bash install_fish.sh

#### Install torrent manager ####
sudo apt-get install qbittorrent

#### Install calculator ####
sudo apt-get install kcalc 

#### Install skype ####
wget https://go.skype.com/skypeforlinux-64.deb
sudo dpkg -i skypeforlinux-64.deb  
rm skypeforlinux-64.deb

#### Install teamviewer ####
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
dpkg -i teamviewer_amd64.deb
rm teamviewer_amd64.deb

#### Purge vim ####
sudo apt purge vim*

#### Install nvim ####
bash install_nvim.sh 3

#### Install Qt #####
wget http://download.qt.io/official_releases/qt/5.10/5.10.0/qt-opensource-linux-x64-5.10.0.run
chmod +x qt-opensource-linux-x64-5.10.0.run
./qt-opensource-linux-x64-5.10.0.run

#### Install LibreOffice ####
wget http://download.documentfoundation.org/libreoffice/stable/5.4.3/deb/x86_64/LibreOffice_5.4.3_Linux_x86-64_deb.tar.gz
tar -xvzf LibreOffice_5.4.3_Linux_x86-64_deb.tar.gz 
cd LibreOffice_5.4.3.2_Linux_x86-64_deb/DEBS
sudo dpkg -i *.deb
rm LibreOffice_5.4.3_Linux_x86-64_deb.tar.gz
 
#### Install Updates ####
sudo apt-get upgrade
