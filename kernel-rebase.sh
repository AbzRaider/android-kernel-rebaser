#!/usr/bin/env bash

# Colours
RED='\033[0;31m'
GREEN='\033[0;32m'
NORMAL='\033[0m'

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
git clone https://github.com/techyminati/alps-4.19 -b alps-mp-t0.mp1.tc2sp1-pr1-V1.90 kernel

# Get the list of Directories of the OEM Kernel
cd oem
OEM_DIR_LIST=$(find -type d -printf "%P\n" | grep -v / | grep -v .git)
cd -

# Start Rebasing
cd kernel
for i in ${OEM_DIR_LIST}; do
	rm -rf ${i}
done

cd -
rsync -av oem/* kernel/
cd kernel

for i in ${OEM_DIR_LIST}; do
	git add ${i}
	git commit -s -m "${i}: Import OEM Changes"
done

git add .
git commit -s -m "Import Remaining OEM Changes"

cd -

echo -e ${GREEN}"Your Kernel has been successfully rebased to ALPS. Please check kernel/"${NORMAL}

# Exit
exit 0
