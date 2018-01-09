#!/bin/bash

overwrite=false
alias_file=~/.alias
if [[ $1 = 'o' || $1 = 'O' ]];then
	overwrite=true
	rm $alias_file
fi

echo "overwrite: $overwrite"

echo "
alias clcmake='cmake -G \'Unix Makefiles\' -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++'" >> $alias_file
