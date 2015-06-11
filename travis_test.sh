#!/usr/bin/env bash

set -ex

# Overwrite our path so that we are using the python version we install
# manually.
export PATH="$HOME/bin:/usr/bin:/bin"
echo $PATH

tmux new -d -s vim

echo "Using Python from: $(which python). Version: $(python --version)"
echo "Using vim from: $(which vim). Version: $(vim --version)"

if [[ $TRAVIS_PYTHON_VERSION =~ "2." ]]; then
   printf "py import sys;print(sys.version);\nquit" | vim  -e -V9myVimLog
else
   printf "py3 import sys;print(sys.version);\nquit" | vim  -e -V9myVimLog
fi

cat myVimLog

python ./test_all.py -v --plugins --session vim
