#!/bin/bash -e

SCRIPT_PATH="$(dirname "$(readlink -f $0)")"

cd "$SCRIPT_PATH/.."

COMMIT_TIMESTAMP="$(git log -1 --pretty=format:%at)"

export ARCH=arm

export CROSS_PREFIX=/host-rootfs/usr/bin/arm-linux-gnueabihf-
export CROSS_CC=/host-rootfs/usr/bin/arm-linux-gnueabihf-gcc

# configure RPi2 kernel
rm -rf .build
make O=.build CROSS_COMPILE=$CROSS_PREFIX bcm2709_defconfig

cd .build
# use timestamp as deb version
echo $COMMIT_TIMESTAMP > .version

make CC=$CROSS_CC bindeb-pkg -j16

# move results
mkdir -p ../.output
mv ../*deb ../.output

# configure RPi kernel
cd "$SCRIPT_PATH/.."
rm -rf .build
make O=.build CROSS_COMPILE=$CROSS_PREFIX bcmrpi_defconfig

cd .build
# use timestamp as deb version
echo $COMMIT_TIMESTAMP > .version

make CC=$CROSS_CC bindeb-pkg -j16
mv ../*deb ../.output

# cleanup
rm -rf *.changes
rm -rf ../.build
