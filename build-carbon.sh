#!/bin/bash -ex

source ~/.zephyrrc
if [ -z "${ZEPHYR_WORK_DIR}" ]; then
    ZEPHYR_WORK_DIR=$PWD
fi

ABS_WORK_DIR=$(cd "${ZEPHYR_WORK_DIR}"; pwd)

function build_sample(){
    local board=$1
    local sample=$2
    local build_dir=$3
    local flash=$4

    cd ${ABS_WORK_DIR}/zephyr

    rm -fr "${build_dir}"

    source zephyr-env.sh
    west build -b ${board} ${sample} --build-dir ${build_dir}
    echo "====================build for ${sample} finished successfully ======"
    if $flash; then
        west flash --build-dir ${build_dir}
    fi
}

## to make normal user able to flash, need to add following lines for udev
## $ cat /etc/udev/rules.d/40-dfuse.rules
## Example udev rules (usually placed in /etc/udev/rules.d)
## Makes STM32 DfuSe device writeable for the console user
##
## ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", TAG+="uaccess"
## #On older systems, a user group like "plugdev" can be given access:
## ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="664", GROUP="plugdev"
## $
## and reboot to make it work
#build_sample 96b_carbon samples/bluetooth/beacon build-carbon-beacon true
#build_sample 96b_carbon samples/bluetooth/beacon build-carbon-ipsp true


function install_openocd(){
    # Common dependencies
    apt install pkg-config automake libtool

    # openocd upstream repository
    git clone git://git.code.sf.net/p/openocd/code openocd-code
    cd openocd-code
    ./bootstrap
    ./configure
    make
    make install
}

function generate_nrf51_cfg(){
cat >carbon-nrf51-stlink-v2-1.cfg <<__EOF__
source [find interface/stlink-v2-1.cfg]
transport select hla_swd

set WORKAREASIZE 0x4000
source [find target/nrf51.cfg]
__EOF__
}

# $sudo openocd -f ./carbon-nrf51/carbon-nrf51-stlink-v2.cfg
# $telnet localhost 4444
# >program /home/siddhesh/src/upstream/zephyr/zephyr-project/samples/bluetooth/hci_spi/outdir/96b_carbon_nrf51/zephyr.hex verify
# >exit
# $
build_sample 96b_carbon_nrf51 samples/bluetooth/hci_spi build-carbon-nrf51-hci_spi true
# sudo openocd -f ${ABS_WORK_DIR}/carbon-nrf51/carbon-nrf51-stlink-v2.cfg -c "program ${ABS_WORK_DIR}/zephyr/build-carbon-nrf51-hci_spi/zephyr/zephyr.hex verify exit"
