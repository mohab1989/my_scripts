#!/bin/bash

# Project parameters:
cmake_minimum_required="2.0"
project_directory="./"
project_name="default_project" 
major_version="1"
minor_version="0"
target_type="executable"        # values: executable | static_lib |
                                # shared_lib | module_lib
cxx_standard="11r"              # values: (98/ 11/ 14/ 17)r 
                                # if r cxx_standard is required
cxx_standard_required=OFF
disable_testing=false
#########################################################################
############################# parse inputs ##############################
#########################################################################

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
echo $key
case $key in 
    -m|--min_cmake_version)
    cmake_minimum_required=$2
    shift # past argument
    shift # past value
    ;;
    -d|--project_directory)
    project_directory=$2
    #echo $project_directory
    shift # past argument
    shift # past value
    ;;
    -p|--project)
    project_name=$2
    shift # past argument
    shift # past value
    ;;
    -V|--major_version)
    major_version=
    shift # past argument
    shift # past value
    ;;
    -v|--minor_version)
    minor_version=$2
    shift # past argument
    shift # past value
    ;;
    -s|--cxx_standard)
    cxx_standard=${2,,}
    shift # past argument
    shift # past value
    ;;
    -t|--target_type)
    target_type=${2,,}
    shift # past argument
    shift # past value
    ;;
    dt|disable_testing)
    disable_testing=true
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

project_name_captial=${project_name^^}
project_name_small=${project_name,,}

#########################################################################
################### Create Project Directories Tree #####################
#########################################################################

mkdir $project_directory
cd $project_directory
mkdir -p src include cmake/modules

# Create dummy source file
echo "
int main(int argc, char*[] argv){
}">>src/${project_name_small}.cpp

# Create file to take cmake inputs to program
echo "
${project_name_captial}_VERSION_MAJOR @${project_name_captial}_VERSION_MAJOR@
${project_name_captial}_VERSION_MINOR @${project_name_captial}_VERSION_MINOR@
">>${project_name_small}_version.h.in

#########################################################################
####################### Create CMakeLists.txt ###########################
#########################################################################

add_target=""

# Set type of output
if [ $target_type = "executable" ];
then
    add_target="add_executable(${project_name}"
elif [ $target_type = "static_lib" ];
then
    add_target="add_library(${project_name} STATIC "

elif [ $target_type = "shared_lib" ];
then
    add_target="add_library(${project_name} SHARED "
elif [ $target_type = "module_lib" ];
then
    add_target="add_library(${project_name} MODULE"
else
    echo "--target_type (executable | static_lib | shared_lib | module_lib)"
    exit 1
fi

# Set standard and check if its required
if [ ${cxx_standard:2} = "r" ];
then
    cxx_standard_required=ON
fi
cxx_standard=${cxx_standard:0:2}

# Remove previously made CMakeLists.txt
rm CMakeLists.txt

# Generate CMakeLists.txt file
echo "
# Set cmake minimum version required
cmake_minimum_required(VERSION $cmake_minimum_required)

# Name Project
project($project_name)

# Project version number
set(${project_name_captial}_VERSION_MAJOR $major_version)
set(${project_name_captial}_VERSION_MINOR $minor_version)i

# configure a header file to pass some of the CMake settings
# to the source code
configure_file(
\"\${PROJECT_SOURCE_DIR}/${project_name_small}_version.h.in\"
\"\${PROJECT_SOURCE_DIR}/include/${project_name_small}_version.h\"
)

# Set Variables
set(SOURCE_FILES src/${project_name_small}.cpp)

# Add SOURCE_FILES to executable/library
${add_target}\${SOURCE_FILES})

# Add include directories
target_include_directories(${project_name} PUBLIC \${PROJECT_SOURCE_DIR}/include)

# Set 
set_target_properties(${project_name} PROPERTIES
    CXX_STANDARD $cxx_standard
    CXX_STANDARD_REQUIRED $cxx_standard_required
    CXX_EXTENSIONS OFF
)">>CMakeLists.txt

if [ $disable_testing = false ];
then
echo
"

">>CMakeLists.txt
fi
