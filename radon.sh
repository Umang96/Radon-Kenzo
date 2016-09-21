#
# Custom build script for Radon kernel
#
# Copyright 2016 Umang Leekha (Umang96@xda)
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it.
#

yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
gre='\e[0;32m'
echo -e ""
echo -e "$yellow ====================================\n\n Welcome to Radon building program !\n\n ====================================\n\n 1.Build Radon stable version\n\n 2.Build Radon test version\n"
echo -n " Enter your choice:"
read choice
echo -e "\n"
echo -n " Make gestures version (y/n):"
read gestures
echo -e "$white"
Start=$(date +"%s")
KERNEL_DIR=$PWD
DTBTOOL=$KERNEL_DIR/dtbTool
cd $KERNEL_DIR
export ARCH=arm64
export CROSS_COMPILE="/home/umang/toolchain/aarch64-linux-linaro-android-4.9/bin/aarch64-linux-android-"
export LD_LIBRARY_PATH=home/umang/toolchain/aarch64-linux-linaro-android-4.9/lib/
STRIP="/home/umang/toolchain/aarch64-linux-linaro-android-4.9/bin/aarch64-linux-android-strip"
make clean
make cyanogenmod_kenzo_defconfig
export KBUILD_BUILD_HOST="G5070"
export KBUILD_BUILD_USER="Umang"
make -j4
time=$(date +"%d-%m-%y-%T")
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/build/tools/dt.img
if [ $gestures == "y" ]; then
cp $KERNEL_DIR/arch/arm64/boot/Image $KERNEL_DIR/build/tools/Imageg
elif [ $gestures == "n" ]; then
cp $KERNEL_DIR/arch/arm64/boot/Image $KERNEL_DIR/build/tools/Image
fi
rm -rf $KEREL_DIR/build/system
mkdir -p $KERNEL_DIR/build/system/lib/modules
cp $KERNEL_DIR/drivers/staging/prima/wlan.ko $KERNEL_DIR/build/system/lib/modules/wlan.ko
cd $KERNEL_DIR/build
cd $KERNEL_DIR/build/system/lib/modules/
$STRIP --strip-unneeded *.ko
zimage=$KERNEL_DIR/arch/arm64/boot/Image
if ! [ -a $zimage ];
then
echo -e "$red << Failed to compile zImage, fix the errors first >>$white"
else
cd $KERNEL_DIR/build
rm *.zip
if [ $choice == 2 ]; then
zip -r Radon-Kenzo-Test-$time.zip *
else
zip -r Radon-Kenzo-Stable.zip *
fi
End=$(date +"%s")
Diff=$(($End - $Start))
echo -e "$gre << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds >>$white"
fi
cd $KERNEL_DIR
