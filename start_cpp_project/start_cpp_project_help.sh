echo "
==========================================================================
start_cpp_proejct is shell script that automates the process of creating 
a new c++ project and handle creating it's CMakeLists.txt Doxyfile,
and including testing libraries, profilers and so on.
==========================================================================

*inputs:
-m | --min_cmake_version : set the minimum version required for cmake 
                           default=3.2.

-d | --project_directory : set the project directory.
                           default=./

-p | --project_name      : set name of project.
                           default=default_project.

-V | --major_version     : set the major version of the project.
                           default=1.

-v | --minor_version     : set the minor version of the project.
                           default=0.

-s | --cxx_standard      : set the cxx cxx_standard 
                           values (98 | 11 | 14 | 17 |..)[r]
                           if r then standard is required by cmake
                           default=11r.

-t | --target_type       : set output type
                           values (executable| static_lib| shared_lib| module)
                           default=executable.

dt | disable_testing     : disable including and linking to Gtest and GMock
                           default=false.

-h | --help              : display this help.
"
