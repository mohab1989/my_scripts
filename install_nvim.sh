pip_version=$1
if [ $pip_version -eq "3" ];then
    python_version="python3"
else
    python_version="python2"
fi

vim_plug_directory=~/.local/share/nvim/site/autoload/
plugins_directory=~/.local/share/nvim/plugged
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

# Make directory for init.vim 
mkdir -p $nvim_config_dir

# Installing vim-plug
if [ ! -f $plug_vim_file ]; then
	echo "Downloading plug.vim..."
    curl -fLo $vim_plug_directory --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
	echo "plug.vim already installed"
fi

# adding plugins to init .vim
if grep -q "call plug#begin" $nvim_config_file;then
	echo "plug begin already added to init.vim"
else
	echo "adding plugins to to neovim"
	echo "
let g:ycm_global_ycm_extra_conf="~/ycm_extra_conf.py"

map <C-n> :NERDTreeToggle<CR>
	
\" Specify a directory for plugins
\" - For Neovim: ~/.local/share/nvim/plugged
\" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('$plugins_directory')

\" Make sure you use single quotes

\" universal defaults: https://github.com/tpope/vim-sensible
Plug 'tpope/vim-sensible'

\" Show git diff in gutter: https://github.com/airblade/vim-gitgutter
Plug 'airblade/vim-gitgutter'

\" The NERDTree is a file system explorer for the Vim editor:
\" https://github.com/scrooloose/nerdtree
Plug 'scrooloose/nerdtree'

\" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

\" It's an interactive Unix filter for command-line that can be used with any list; \" files, command history, processes, hostnames, bookmarks, git commits, etc.
\" https://github.com/junegunn/fzf
\" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'do': './install --all' }

\" Install YouCompleteMe clang completer for c/c++ autocompletion
Plug 'Valloric/YouCompleteMe', { 'do': '$python_version install.py --clang-completer' }

\" YouCompleteMe Generator, generates dependancies so that YCM can use them in
\" autocompletion
\" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }


\" Any valid git URL is allowed
\" Plug 'https://github.com/junegunn/vim-github-dashboard.git'

\" Multiple Plug commands can be written in a single line using | separators
\" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

\" On-demand loading
\" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
\" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }


\" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
\" Plug 'fatih/vim-go', { 'tag': '*' }

\" Plugin options
\" Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }


\" Unmanaged plugin (manually installed and updated)
\" Plug '~/my-prototype-plugin'

\" Initialize plugin system
call plug#end()" >> $nvim_config_file
fi
