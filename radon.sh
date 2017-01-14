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
echo -e "$gre ====================================\n\n Welcome to Radon building program !\n\n ====================================\n\n 1.Build radon cm ng fpc\n\n 2.Build radon cm ng gdx\n"
echo -n " Enter your choice:"
read goodix
echo -e "$white"
KERNEL_DIR=$PWD
cd arch/arm/boot/dts/
rm *.dtb
cd $KERNEL_DIR
Start=$(date +"%s")
DTBTOOL=$KERNEL_DIR/dtbTool
cd $KERNEL_DIR
export ARCH=arm64
export CROSS_COMPILE="/home/$USER/toolchain/aarch64-linux-google-android-4.9/bin/aarch64-linux-android-"
export LD_LIBRARY_PATH=home/$USER/toolchain/aarch64-linux-google-android-4.9/lib/
STRIP="/home/$USER/toolchain/aarch64-linux-google-android-4.9/bin/aarch64-linux-android-strip"
make clean
if [ $goodix == 2 ]; then
git apply goodix.patch
elif [ $goodix == 1 ]; then
git apply -R goodix.patch
fi
make cyanogenmod_kenzo_defconfig
export KBUILD_BUILD_HOST="lenovo"
export KBUILD_BUILD_USER="umang"
make -j4
time=$(date +"%d-%m-%y-%T")
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
if [ $goodix -eq 1 ]; then
mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/build/tools/dt1.img
elif [ $goodix -eq 2 ]; then
mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/build/tools/dt2.img
fi
if [ $goodix == 1 ]; then
cp $KERNEL_DIR/arch/arm64/boot/Image $KERNEL_DIR/build/tools/Image1
elif [ $goodix == 2 ]; then
cp $KERNEL_DIR/arch/arm64/boot/Image $KERNEL_DIR/build/tools/Image2
fi
zimage=$KERNEL_DIR/arch/arm64/boot/Image
if ! [ -a $zimage ];
then
echo -e "$red << Failed to compile zImage, fix the errors first >>$white"
else
cd $KERNEL_DIR/build
rm *.zip
zip -r Radon-Kenzo-Cm-Ng.zip *
End=$(date +"%s")
Diff=$(($End - $Start))
echo -e "$gre << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds, variant($overclock$goodix) >>$white"
fi
cd $KERNEL_DIR
if [ $goodix == 2 ]; then
git apply -R goodix.patch
fi
