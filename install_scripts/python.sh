#!/bin/bash

PYTHONE_DONE=

set -e

if [ ! -d configurations ];then
    ROOT=$(pwd)/..
else
    ROOT=$(pwd)
fi

if [ ! $GIT_DONE ];then
    source "$ROOT/install_scripts/git.sh"
fi

echo "Pyenv installation.. pwd: $PWD, root: $ROOT"

mkdir -p $HOME/.lib

export PYENV_ROOT="$HOME/.pyenv"
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

set +e

env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install -s 2.7.13
env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install -s 3.6.1

pip install jupyter jupyterthemes
jt -t grade3 -f source -fs 95 -altp -tfs 11 -nfs 115 -cellw 88% -T

echo "---"
echo "Type \"source $ENVFILE\""

set -e

PYTHONE_DONE=1
