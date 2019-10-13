#!/bin/bash -ex

source ~/.zephyrrc
if [ -z "${ZEPHYR_WORK_DIR}" ]; then
    ZEPHYR_WORK_DIR=$PWD
fi

ABS_WORK_DIR=$(cd "${ZEPHYR_WORK_DIR}"; pwd)
cd ${ABS_WORK_DIR}

SDK_URL="https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.10.3/zephyr-sdk-0.10.3-setup.run"
SDK_NAME=$(basename ${SDK_URL})
#wget "${SDK_URL}"
chmod +x "${SDK_NAME}"
# check zephyr-sdk/sdk_version for version info
./${SDK_NAME} -- -d ${ABS_WORK_DIR}/zephyr-sdk
