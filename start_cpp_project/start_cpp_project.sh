#!/bin/bash

# Project parameters:
cmake_minimum_required="3.2"
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
case $key in 
    -m|--min_cmake_version)
    cmake_minimum_required=$2
    shift # past argument
    shift # past value
    ;;
    -d|--project_directory)
    project_directory=$2
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
    -h|--help)
    source start_cpp_project_help.sh
    shift #past argument
    exit 0
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
testing_project_name=${project_name}_testing

#########################################################################
################### Create Project Directories Tree #####################
#########################################################################
mkdir -p $project_directory

# Generate license in project directory
source generate_license.sh mit $project_directory

cd $project_directory
mkdir -p src include cmake/modules tests

# If testing enabled download FindGMock.cmake file
if [ $disable_testing = false ];
then
wget -P ./cmake/modules/ \
https://raw.githubusercontent.com/mohab1989/MyAlgorithms/master/Sorting/cmake/modules/FindGMock.cmake

# Create dummy testing source file
cat LICENSE >> tests/${project_name_small}_test.cpp
echo "
#include<gtest/gtest.h>
#include<gmock/gmock.h>

int main(int argc, char* argv[]) {
    ::testing::InitGoogleTest(&argc,argv);
    ::testing::InitGoogleMock(&argc,argv);

    return RUN_ALL_TESTS();
}
">>tests/${project_name_small}_test.cpp
fi

# Create file to take cmake inputs to program
echo "
#define ${project_name_captial}_VERSION_MAJOR @${project_name_captial}_VERSION_MAJOR@
#define ${project_name_captial}_VERSION_MINOR @${project_name_captial}_VERSION_MINOR@
">>${project_name_small}_version.h.in


# Create dummy source file
cat LICENSE >> src/${project_name_small}.cpp
echo "
#include<${project_name_small}_version.h>
int main(int argc, char* argv[]){
    return 0;
}">>src/${project_name_small}.cpp
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
    add_target="add_library(${project_name} STATIC"

elif [ $target_type = "shared_lib" ];
then
    add_target="add_library(${project_name} SHARED "
elif [ $target_type = "module" ];
then
    add_target="add_library(${project_name} MODULE"
else
    echo "--target_type (executable | static_lib | shared_lib | module)"
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
set(${project_name_captial}_VERSION_MINOR $minor_version)

# configure a header file to pass some of the CMake settings
# to the source code
configure_file(
\"\${PROJECT_SOURCE_DIR}/${project_name_small}_version.h.in\"
\"\${PROJECT_SOURCE_DIR}/include/${project_name_small}_version.h\"
)

# Set Variables
set(SOURCE_FILES src/${project_name_small}.cpp)

# Add SOURCE_FILES to executable/library
${add_target} \${SOURCE_FILES})

# Add include directories
target_include_directories(${project_name} PUBLIC \${PROJECT_SOURCE_DIR}/include)

# Set some properties (standard)
set_target_properties(${project_name} PROPERTIES
    CXX_STANDARD $cxx_standard
    CXX_STANDARD_REQUIRED $cxx_standard_required
    CXX_EXTENSIONS OFF
    )
# Export compile command json file for use with source trail and YCM
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
">>CMakeLists.txt

if [ $disable_testing = false ];
then
echo "
# Add find GMock.cmake module to cmake modules
list(APPEND CMAKE_MODULE_PATH \${PROJECT_SOURCE_DIR}/cmake/modules)

# Find Gtest and GMock packages
find_package(GTest)
find_package(GMock)
if(NOT GTEST_FOUND)
    message(WARNING \"GTest couldn't be found\")
else()
    message(\"GTest Found\")
endif()
if(NOT GMOCK_FOUND)
    message(WARNING \"GMock couldn't be found\")
else()
    message(\"GMock Found\")
endif()

if(GTEST_FOUND AND GMOCK_FOUND)
# Set testing project sources 
set(TESTING_SOURCES \${PROJECT_SOURCE_DIR}/tests/${project_name_small}_test.cpp)

# Make Testing executable
add_executable(${testing_project_name} \${TESTING_SOURCES})

# Include Project's Include dir plus Gtest and GMock include dirs
target_include_directories(${testing_project_name} PUBLIC \${PROJECT_SOURCE_DIR}/include \${GTEST_INCLUDE_DIRS} \${GMOCK_INCLUDE_DIRS})

# Link with Gtest and GMock libs
target_link_libraries(${testing_project_name} GTest::GTest GTest::Main \${GMOCK_BOTH_LIBRARIES})

set_target_properties(${testing_project_name} PROPERTIES
    CXX_STANDARD $cxx_standard
    CXX_STANDARD_REQUIRED $cxx_standard_required
    CXX_EXTENSIONS OFF
    )
# Enabling testing
enable_testing()
add_test(${project_name}_test testing_project_name)
endif()
">>CMakeLists.txt
fi

#########################################################################
##################### Add Doxygen Documentation #########################
#########################################################################

