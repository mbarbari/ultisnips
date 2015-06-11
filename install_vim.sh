#!/usr/bin/env bash

# Installs a known version of vim in the travis test runner.
set -ex

# Overwrite our path so that we are using the python version we install
# manually.
export PATH="$HOME/bin:/usr/bin:/bin"
echo $PATH

build_vanilla_vim () {
   local URL=$1; shift;

   mkdir vim_build
   pushd vim_build

   until curl $URL -o vim.tar.bz2; do sleep 10; done
   tar xjf vim.tar.bz2
   cd vim${VIM_VERSION}

   local PYTHON_CONFIG_DIR=$(dirname $(find $HOME/lib -iname 'config.c' | grep $TRAVIS_PYTHON_VERSION))
   local PYTHON_BUILD_CONFIG=""
   if [[ $TRAVIS_PYTHON_VERSION =~ "2." ]]; then
      PYTHON_BUILD_CONFIG="--enable-pythoninterp --with-python-config-dir=${PYTHON_CONFIG_DIR}"
   else
      PYTHON_BUILD_CONFIG="--enable-python3interp --with-python3-config-dir=${PYTHON_CONFIG_DIR}"
   fi
   ./configure \
      --prefix=${HOME} \
      --disable-nls \
      --disable-sysmouse \
      --disable-gpm \
      --enable-gui=no \
      --enable-multibyte \
      --with-features=huge \
      --with-tlib=ncurses \
      --without-x \
      ${PYTHON_BUILD_CONFIG}

   make install
   popd

   rm -rf vim_build
}

build_python () {
   local PYTHON_VERSION="$(python --version 2>&1 | sed 's/Python '//)"
   local URL="https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"

   mkdir python_build
   pushd python_build

   until curl $URL -o python.tar.gz; do sleep 10; done
   tar xzf python.tar.gz
   cd Python-${PYTHON_VERSION}

   ./configure --prefix=${HOME} 
   make install
   popd
}

build_python 

if [[ $VIM_VERSION == "74" ]]; then
   build_vanilla_vim ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
elif [[ $VIM_VERSION == "NEOVIM" ]]; then
   pip install neovim
else
   echo "Unknown VIM_VERSION: $VIM_VERSION"
   exit 1
fi

# Clone the dependent plugins we want to use.
./test_all.py --clone-plugins
