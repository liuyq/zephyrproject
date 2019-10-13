#!/bin/bash -ex

source ~/.zephyrrc

if [ -z "${ZEPHYR_WORK_DIR}" ]; then
    WORK_DIR=$PWD
else
    WORK_DIR="${ZEPHYR_WORK_DIR}"
fi

WORK_DIR=$(cd "${WORK_DIR}"; pwd)
cd ${WORK_DIR}

sudo apt-get install libusb-1.0-0-dev autoconf
if [ -d "${WORK_DIR}/dfu-util" ]; then
    git clone git://git.code.sf.net/p/dfu-util/dfu-util
fi
cd dfu-util
make maintainer-clean
git pull
./autogen.sh
./configure  # on most systems
make
