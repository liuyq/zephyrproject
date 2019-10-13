:x

source ~/.zephyrrc

if [ -z "${ZEPHYR_WORK_DIR}" ]; then
    ZEPHYR_WORK_DIR=$PWD
fi

ABS_WORK_DIR=$(cd "${ZEPHYR_WORK_DIR}"; pwd)
cd ${ABS_WORK_DIR}

# for building
sudo apt install cmake python3-pip ninja-build
# for 96carbon flash
sudo apt install dfu-util
# for 96carbon_nrf51 flash
sudo apt install openocd

pip3 install --user -U west
if [ ! -d "${ABS_WORK_DIR}" ]; then
    west init "${ABS_WORK_DIR}"
fi
cd ${ABS_WORK_DIR}
west update
pip3 install --user -r zephyr/scripts/requirements.txt
