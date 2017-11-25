#!/bin/bash
#
#    LAPACK installer
#
#    Copyright (C) 2017 Gwangmin Lee
#    
#    Author: Gwangmin Lee <gwangmin0123@gmail.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -e

ROOT=$(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd)
PWD=$(pwd)
. $ROOT/envset.sh

PKG_NAME="lapack"
FOLDER="$PKG_NAME*"
TMP_DIR=$ROOT/tmp
REPO_URL="https://github.com/Reference-LAPACK/lapack-release"
mkdir -p $TMP_DIR && cd $TMP_DIR
git clone --depth=1 $REPO_URL
cd $FOLDER
TAG=$(grep VERSION README.md | cut -d' ' -f3 | sort -V | tail -n1)
VER=$TAG
VERFILE=""
if $(pkg-config --exists $PKG_NAME);then
  INSTALLED_VERSION=$(pkg-config --modversion $PKG_NAME)
fi

if [ ! -z $REINSTALL ] || [ -z $INSTALLED_VERSION ] || [ $VER != $INSTALLED_VERSION ]; then
  echo "$PKG_NAME $VER installation.. pwd: $PWD, root: $ROOT"

  mkdir -p build && cd build && \
    cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$INSTALLDIR .. && \
    make -s -j$(nproc) && make -s install 1>/dev/null
else
  echo "$PKG_NAME $VER is already installed"
fi

cd $ROOT && rm -rf $TMP_DIR

cd $ROOT
