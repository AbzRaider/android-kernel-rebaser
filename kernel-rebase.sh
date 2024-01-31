#!/usr/bin/env bash

# Colours
RED='\033[0;31m'
GREEN='\033[0;32m'
NORMAL='\033[0m'
OEM=Realme

# Project Directory
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Variables
OEM_KERNEL=${1}


# Help Function
usage() {
	echo -e "${0} \"link to oem kernel source (git)\"
	>> eg: ${0} \"https://github.com/MiCode/Xiaomi_Kernel_OpenSource.git -b dandelion-q-oss\" "
}

# Abort Function
abort() {
	[ ! -z "${@}" ] && echo -e ${RED}"${@}"${NORMAL}
	exit 1
}

# Clone the OEM Kernel Source
git clone --depth=1 --single-branch $(echo ${OEM_KERNEL}) oem

# Clone the ALPS Common Kernel Source
git clone https://github.com/prathamdby/alps-S-4.14 kernel
# Get the list of MISC MTK Directories of the OEM Kernel
cd oem
cd drivers/misc/mediatek/
ls
OEM_DIR_LIST_MISCMTK=$(find -type d -printf "%P\n" | grep -v / | grep -v .git)
cd ..
cd ..
cd ..
cd ..

# Start Rebasing MISC_MTK
cd kernel/drivers/misc/mediatek
for i in ${OEM_DIR_LIST_MISCMTK}; do
	rm -rf ${i}
done

cd ..
cd ..
cd ..
cd ..

rsync -av  oem/drivers/misc/mediatek/* kernel/drivers/misc/mediatek
cd kernel

for i in ${OEM_DIR_LIST_MISCMTK}; do
	git add drivers/misc/mediatek/${i}
	git commit -s -m "mediatek: ${i}: Import $OEM Changes"
done

cd ..
ls
# Get the list of oem/kernel Directories of the OEM Kernel
cd oem
cd kernel
OEM_DIR_LIST_KERNEL=$(find -type d -printf "%P\n" | grep -v / | grep -v .git)
cd ..
cd ..
ls

# Start Rebasing (kernel/kernel)
cd kernel/kernel
for i in ${OEM_DIR_LIST_KERNEL}; do
        rm -rf ${i}
done

cd ..
cd ..

rsync -av oem/kernel/* kernel/kernel
cd kernel

for i in ${OEM_DIR_LIST_KERNEL}; do
        git add kernel/${i}
        git commit -s -m "kernel: ${i}: Import $OEM Changes"
done

cd ..

# Get the list of oem/sound Directories of the OEM Kernel
cd oem
cd sound
OEM_DIR_LIST_SOUND=$(find -type d -printf "%P\n" | grep -v / | grep -v .git)
cd ..
cd ..

# Start Rebasing (kernel/sound)
cd kernel/sound
for i in ${OEM_DIR_LIST_SOUND}; do
        rm -rf ${i}
done

cd ..
cd ..

rsync -av oem/sound/* kernel/sound
cd kernel

for i in ${OEM_DIR_LIST_SOUND}; do
        git add sound/${i}
        git commit -s -m "sound: ${i}: Import $OEM Changes"
done

cd ..

# Get the list of oem/drivers/input/touchscreen Directories of the OEM Kernel
cd oem
cd drivers/input/touchscreen
OEM_DIR_LIST_TOUCHSCREEN=$(find -type d -printf "%P\n" | grep -v / | grep -v .git)
cd ..
cd ..
cd ..
cd ..

# Start Rebasing (kernel/drivers/input/touchscreen)
cd kernel/drivers/input/touchscreen

for i in ${OEM_DIR_LIST_TOUCHSCREEN}; do
        rm -rf ${i}
done

cd ..
cd ..
cd ..
cd ..

ls 

rsync -av oem/drivers/input/touchscreen/* kernel/drivers/input/touchscreen
cd kernel

for i in ${OEM_DIR_LIST_TOUCHSCREEN}; do
        git add drivers/input/touchscreen/${i}
        git commit -s -m "touchscreen: ${i}: Import $OEM Changes"
done

cd ..

# Start Rebasing (Input)
cd kernel/drivers/input

for i in ${OEM_DIR_LIST_INP}; do
        rm -rf ${i}
done

cd ..
cd ..
cd ..


rsync -av oem/drivers/input/* kernel/drivers/input
cd kernel

for i in ${OEM_DIR_LIST_DRV}; do
        git add kernel/drivers/input/${i}
        git commit -s -m "input: ${i}: Import Remaining OEM Changes"
done

cd ..

# Get the list of oem/drivers Directories of the OEM Kernel
cd oem
cd drivers
OEM_DIR_LIST_DRV=$(find -type d -printf "%P\n" | grep -v / | grep -v .git)
cd ..
cd ..


# Start Rebasing (drivers)
cd kernel/drivers

for i in ${OEM_DIR_LIST_DRV}; do
        rm -rf ${i}
done

cd ..
cd ..

rsync -av oem/drivers/* kernel/drivers
cd kernel

for i in ${OEM_DIR_LIST_DRV}; do
        git add drivers/${i}
        git commit -s -m "drivers: ${i}: Import $OEM Changes"
done

cd ..

# Get the list of Directories of the OEM Kernel
cd oem
OEM_DIR_LIST=$(find -type d -printf "%P\n" | grep -v / | grep -v .git)
cd -

# Start Rebasing
cd kernel
for i in ${OEM_DIR_LIST}; do
	rm -rf ${i}
done

cd ..
rsync -av oem/* kernel/
cd kernel

for i in ${OEM_DIR_LIST}; do
	git add ${i}
	git commit -s -m "${i}: Import $OEM Changes"
done

git add .
git commit -s -m "Import Remaining OEM Changes"

cd ..


echo -e ${GREEN}"Your Kernel has been successfully rebased to ALPS. Please check kernel/"${NORMAL}

# Exit
exit 0
