#!/bin/bash

# Project parameters:

project_name="default_project"
c_compiler=""
cxx_compiler=""

##### parse inputs #####
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -p|--project)
    project_name='$key'
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

