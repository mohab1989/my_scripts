pip_version=$1
if [ $pip_version -eq "3" ];then
    python_version="python3"
else
    python_version="python2"
fi

vim_plug_directory=~/.local/share/nvim/site/autoload/
plugins_directory=~/.local/share/nvim/plugged
you_complete_me_directory= $plugins_directory'/you_complete_me'
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
\"let g:ycm_global_ycm_extra_conf="~/ycm_extra_conf.py"

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

# Run PlugInstall to install all plugins
nvim +PlugInstall

echo "
import os
import os.path
import fnmatch
import logging
import ycm_core
import re

BASE_FLAGS = [
        '-Wall',
        '-Wextra',
        '-Wno-long-long',
        '-Wno-variadic-macros',
        '-fexceptions',
        '-ferror-limit=10000',
        '-DNDEBUG',
        '-std=c++14',
        '-xc++',
        '-I/usr/lib/',
        '-I/usr/include/',
        '-I/usr/include/c++/5/'
        ]

SOURCE_EXTENSIONS = [
        '.cpp',
        '.cxx',
        '.cc',
        '.c',
        '.m',
        '.mm'
        ]

SOURCE_DIRECTORIES = [
        'src',
        'lib'
        ]

HEADER_EXTENSIONS = [
        '.h',
        '.hxx',
        '.hpp',
        '.hh'
        ]

HEADER_DIRECTORIES = [
        'include'
        ]

def IsHeaderFile(filename):
    extension = os.path.splitext(filename)[1]
    return extension in HEADER_EXTENSIONS

def GetCompilationInfoForFile(database, filename):
    if IsHeaderFile(filename):
        basename = os.path.splitext(filename)[0]
        for extension in SOURCE_EXTENSIONS:
            # Get info from the source files by replacing the extension.
            replacement_file = basename + extension
            if os.path.exists(replacement_file):
                compilation_info = database.GetCompilationInfoForFile(replacement_file)
                if compilation_info.compiler_flags_:
                    return compilation_info
            # If that wasn't successful, try replacing possible header directory with possible source directories.
            for header_dir in HEADER_DIRECTORIES:
                for source_dir in SOURCE_DIRECTORIES:
                    src_file = replacement_file.replace(header_dir, source_dir)
                    if os.path.exists(src_file):
                        compilation_info = database.GetCompilationInfoForFile(src_file)
                        if compilation_info.compiler_flags_:
                            return compilation_info
        return None
    return database.GetCompilationInfoForFile(filename)

def FindNearest(path, target, build_folder):
    candidate = os.path.join(path, target)
    if(os.path.isfile(candidate) or os.path.isdir(candidate)):
        logging.info(\"Found nearest \" + target + \" at \" + candidate)
        return candidate;

    parent = os.path.dirname(os.path.abspath(path));
    if(parent == path):
        raise RuntimeError(\"Could not find \" + target);

    if(build_folder):
        candidate = os.path.join(parent, build_folder, target)
        if(os.path.isfile(candidate) or os.path.isdir(candidate)):
            logging.info(\"Found nearest \" + target + \" in build folder at \" + candidate)
            return candidate;

    return FindNearest(parent, target, build_folder)

def MakeRelativePathsInFlagsAbsolute(flags, working_directory):
    if not working_directory:
        return list(flags)
    new_flags = []
    make_next_absolute = False
    path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os.path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith(path_flag):
                path = flag[ len(path_flag): ]
                new_flag = path_flag + os.path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append(new_flag)
    return new_flags


def FlagsForClangComplete(root):
    try:
        clang_complete_path = FindNearest(root, '.clang_complete')
        clang_complete_flags = open(clang_complete_path, 'r').read().splitlines()
        return clang_complete_flags
    except:
        return None

def FlagsForInclude(root):
    try:
        include_path = FindNearest(root, 'include')
        flags = []
        for dirroot, dirnames, filenames in os.walk(include_path):
            for dir_path in dirnames:
                real_path = os.path.join(dirroot, dir_path)
                flags = flags + ["-I" + real_path]
        return flags
    except:
        return None

def FlagsForCompilationDatabase(root, filename):
    try:
        # Last argument of next function is the name of the build folder for
        # out of source projects
        compilation_db_path = FindNearest(root, 'compile_commands.json', 'build')
        compilation_db_dir = os.path.dirname(compilation_db_path)
        logging.info(\"Set compilation database directory to \" + compilation_db_dir)
        compilation_db =  ycm_core.CompilationDatabase(compilation_db_dir)
        if not compilation_db:
            logging.info(\"Compilation database file found but unable to load\")
            return None
        compilation_info = GetCompilationInfoForFile(compilation_db, filename)
        if not compilation_info:
            logging.info(\"No compilation info for \" + filename + \" in compilation database\")
            return None
        return MakeRelativePathsInFlagsAbsolute(
                compilation_info.compiler_flags_,
                compilation_info.compiler_working_dir_)
    except:
        return None

def FlagsForFile(filename):
    root = os.path.realpath(filename);
    compilation_db_flags = FlagsForCompilationDatabase(root, filename)
    if compilation_db_flags:
        final_flags = compilation_db_flags
    else:
        final_flags = BASE_FLAGS
        clang_flags = FlagsForClangComplete(root)
        if clang_flags:
            final_flags = final_flags + clang_flags
        include_flags = FlagsForInclude(root)
        if include_flags:
            final_flags = final_flags + include_flags
    return {
            'flags': final_flags,
            'do_cache': True
            }" >>