#!/usr/bin/env bash

set -ex

# See travis_install.sh to why this is needed.
export PATH="$HOME/bin:/usr/bin:/bin"
echo $PATH

tmux new -d -s vim

PYTHON="/home/bin/python"
VIM="/home/bin/vim"

echo "Using python from: $PYTHON. Version: $($PYTHON --version 2>&1)"
echo "Using vim from: $VIM. Version: $($VIMn)"

if [[ $TRAVIS_PYTHON_VERSION =~ "2." ]]; then
   printf "py import sys;print(sys.version);\nquit" | $VIM -e -V9myVimLog
else
   printf "py3 import sys;print(sys.version);\nquit" | $VIM -e -V9myVimLog
fi

cat myVimLog

# NOCOMMIT(#hrapp): you pass the correct vim here
$PYTHON ./test_all.py -v --plugins --session vim
