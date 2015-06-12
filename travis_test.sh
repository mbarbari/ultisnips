#!/usr/bin/env bash

set -ex

# See travis_install.sh to why this is needed.
export PATH="$HOME/bin:/usr/bin:/bin"
echo $PATH

tmux new -d -s vim

VIM="${HOME}/bin/vim"

if [[ $TRAVIS_PYTHON_VERSION =~ "2." ]]; then
   PYTHON="${HOME}/bin/python"
   PY_IN_VIM="py"
else
   PYTHON="${HOME}/bin/python3"
   PY_IN_VIM="py3"
fi

echo "Using python from: $PYTHON. Version: $($PYTHON --version 2>&1)"
echo "Using vim from: $VIM. Version: $($VIMn)"

printf "${PY_IN_VIM} import sys;print(sys.version);\nquit" | $VIM -e -V9myVimLog
cat myVimLog

# NOCOM(#sirver): remove SimpleExpand again.
$PYTHON ./test_all.py -v --plugins --session vim --vim $VIM SimpleExpand_ExpectCorrectResult
