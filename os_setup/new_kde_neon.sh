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

#### Purge vim ####

sudo apt purge vim*

#### Install nvim ####

bash install_nvim.sh 3

#### Install Updates ####

sudo apt-get upgrade
