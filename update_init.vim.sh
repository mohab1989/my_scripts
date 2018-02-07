#!/bin/bash

python='python'
overwrite=false

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
	-p|--python)
	if [ $2 = 'python2' ] || [ $2 = 'python3' ];then
		python="$2"
	else
		echo "Values for -p / --python argument is either python2 or python3"
		exit 128
	fi
	shift # past argument
	shift # past value
	;;
	o|overwrite)
	overwrite=true
	shift # past argument
	;;
	--default)
	DEFAULT=YES
	shift # past argument
	;;
	*)    # unknown option
	POSITIONAL+=("$1") # save it in an array for later
	shift # past argument
	;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo python use is: ${python}
echo overwrite existing init.vim: ${overwrite}


plugins_directory=~/.local/share/nvim/plugged
global_ycm_extra_conf=$plugins_directory'/YouCompleteMe/.ycm_extra_conf.py'

# Search for libclang and get its file path 
libclang_directory=$(echo $(find /usr -type f -name "libclang-*.so*") |  awk '{print $1;}')

# Make directory for neovim config file init.vim (.vimrc)
nvim_config_dir=~/.config/nvim/
nvim_config_file=$nvim_config_dir'init.vim'
if [ $overwrite = true ]; then
	echo "removing $nvim_config_dir"
	rm $nvim_config_file
	echo "Writing new init.vim file"
else
	echo "Append/Create init.vim"
fi

echo "
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

\" It's an interactive Unix filter for command-line that can be used with any list; 
\" files, command history, processes, hostnames, bookmarks, git commits, etc.
\" https://github.com/junegunn/fzf
\" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'do': './install --all' }

\" Install YouCompleteMe clang completer for c/c++ autocompletion
Plug 'Valloric/YouCompleteMe', { 'do': '$python install.py --clang-completer' }

\" Update Ycm generator template
function! UpdateYcmTemplate(info)
    !wget https://raw.githubusercontent.com/mohab1989/my_scripts/master/my_custom_files/ycm_generator_updated_template.py
    !diff template.py ycm_generator_updated_template.py > template.diff
    !patch template.py template.diff
    !rm template.diff ycm_generator_updated_template.py
endfunction


\" YouCompleteMe Generator, generates dependancies so that YCM can use them in
\" autocompletion
\" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' , 'do': function('UpdateYcmTemplate') }

\" Clang based syntax highlight engine for Neovim
\" https://github.com/arakashic/chromatica.nvim
Plug 'arakashic/chromatica.nvim'

\" Lean & mean status/tabline for vim that's light as air with its themes
\"https://github.com/vim-/vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

\" Add folding plugin
Plug 'Konfekt/FastFold'

let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

\" VimDevIcons - Add Icons to Your Plugins
\" https://github.com/ryanoasis/vim-devicons
Plug 'ryanoasis/vim-devicons'

\" Install nerd-fonts
\" https://github.com/ryanoasis/nerd-fonts
Plug 'ryanoasis/nerd-fonts', { 'do': './install.sh' }

\" cmake autocompletion
Plug 'https://github.com/richq/vim-cmake-completion.git'

\" nerdcommenter to support commenting
Plug 'scrooloose/nerdcommenter'

\" get luna color
\" https://github.com/notpratheek/vim-luna.git
Plug 'notpratheek/vim-luna'

\" Install Google style guide checker
Plug 'funorpain/vim-cpplint'

\" Install Google style formatter
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'

\" Any valid git URL is allowed
\" Plug 'https://github.com/junegunn/vim-github-dashboard.git'

\" Multiple Plug commands can be written in a single line using | separators
\" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

\" On-and loading
\" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
\" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }


\" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
\" Plug 'fatih/vim-go', { 'tag': '*' }

\" Plugin options
\" Plug nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }


\" Unmanaged plugin (manually installed and updated)
\" Plug my-prototype-plugin'

\" Initialize plugin system
call plug#end()
call glaive#Install()
\" Set the folding method work on indent
set foldmethod=indent
\" Set location of global_ycm_extra_conf to configure you complete me to use c++ standard libabry
let g:ycm_global_ycm_extra_conf = '$global_ycm_extra_conf'

\" To enable xclip to use os clipboard for copy cut paste operations
set clipboard+=unnamedplus

\" Enable lines numbering
set number

\" Highlight width of text at 80 charachters point
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

\" Make control-N hotkey to open NERDTree
map <C-n> :NERDTreeToggle<CR>

\" Tell chromatica where to find libclang
let g:chromatica#libclang_path = '$libclang_directory'

\" Chromatica is enabled at startup
let g:chromatica#enable_at_startup=1

\" Provide highlight level 
\" 0 = basic semantic highlight with default vim syntax
\" 1 = gets more detailed highlight from libclang with a customized syntax file
let g:chromatica#highlight_feature_level=1

\" Activate chromatica responsive mode to change highlight in nvim insert mode
let g:chromatica#responsive_mode=1

\" Make hidden files shown by default in NERDTree
let NERDTreeShowHidden=1

\"set colorscheme
color luna
colorscheme luna

\" force vim color
set termguicolors

\" set airline theme: https://github.com/vim-airline/vim-airline/wiki/Screenshots
let g:airline_theme='luna'

\" Enable powerline fonts
let g:airline_powerline_fonts = 1

\" Set encoding to UTF-8 to show glyphs (for icons in VimDevIcons)
set encoding=utf8

\" Set Vim font to a Nerd Font 
set guifont=DroidSansMono\ Nerd\ Font\ 11

filetype plugin indent on
\" show existing tab with 4 spaces width
set tabstop=4
\" when indenting with '>', use 4 spaces width
set shiftwidth=4
\" On pressing tab, insert 4 spaces
set expandtab
\" enable list chars to replace tabs and spaces
set list
\" replace tabs and spaces with '>'and '.'
:set lcs=space:.,tab:>-

\" map ctrl-s key to save file
:inoremap <c-s> <Esc>:w<CR>

\"map p to be able to paste same register multiple times.
xnoremap p pgvy">> $nvim_config_file

echo "Done writing init.vim"
