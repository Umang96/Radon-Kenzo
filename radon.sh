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
echo -e "$gre ====================================\n\n Welcome to Radon building program !\n\n ====================================\n\n 1.Build radon miui mm fpc\n\n 2.Build radon miui mm gdx\n"
echo -n " Enter your choice:"
read goodix
echo -e "$gre \n 1.Build radon without qc\n\n 2.Build radon with qc\n"
echo -n " Enter your choice:"
read qc
echo -e "$white"
KERNEL_DIR=$PWD
cd arch/arm/boot/dts/
rm *.dtb > /dev/null 2>&1
cd $KERNEL_DIR
Start=$(date +"%s")
DTBTOOL=$KERNEL_DIR/dtbTool
cd $KERNEL_DIR
export ARCH=arm64
export CROSS_COMPILE="/home/$USER/toolchain/aarch64-linux-googlemm-android-4.9/bin/aarch64-linux-android-"
STRIP="/home/$USER/toolchain/aarch64-linux-googlemm-android-4.9/bin/aarch64-linux-android-strip"
cp $KERNEL_DIR/build/modules/wlan1.ko ~/wlan1.ko > /dev/null 2>&1
cp $KERNEL_DIR/build/modules/wlan2.ko ~/wlan2.ko > /dev/null 2>&1
echo -e "$yellow Running make clean before compiling \n$white"
make clean > /dev/null
mv ~/wlan1.ko $KERNEL_DIR/build/modules/wlan1.ko > /dev/null 2>&1
mv ~/wlan2.ko $KERNEL_DIR/build/modules/wlan2.ko > /dev/null 2>&1
if [ $goodix == 2 ]; then
echo -e "$yellow Applying goodix fingerprint patch \n$white"
git apply goodix.patch
elif [ $goodix == 1 ]; then
git apply -R goodix.patch > /dev/null 2>&1
fi
if [ $qc == 2 ]; then
echo -e "$yellow Applying quick charging patch \n $white"
git apply qc.patch
elif [ $qc == 1 ]; then
git apply -R qc.patch > /dev/null 2>&1
fi
make cyanogenmod_kenzo_defconfig
export KBUILD_BUILD_HOST="lenovo"
export KBUILD_BUILD_USER="umang"
make -j4
time=$(date +"%d-%m-%y-%T")
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
if ([ $goodix -eq 1 ]&&[ $qc -eq 1 ]); then
mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/build/tools/dt11.img
elif ([ $goodix -eq 1 ]&&[ $qc -eq 2 ]); then
mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/build/tools/dt12.img
elif ([ $goodix -eq 2 ]&&[ $qc -eq 1 ]); then
mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/build/tools/dt21.img
elif ([ $goodix -eq 2 ]&&[ $qc -eq 2 ]); then
mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/build/tools/dt22.img
fi
if [ $goodix == 1 ]; then
cp $KERNEL_DIR/arch/arm64/boot/Image $KERNEL_DIR/build/tools/Image1
cp $KERNEL_DIR/drivers/staging/prima/wlan.ko $KERNEL_DIR/build/modules/wlan1.ko
elif [ $goodix == 2 ]; then
cp $KERNEL_DIR/arch/arm64/boot/Image $KERNEL_DIR/build/tools/Image2
cp $KERNEL_DIR/drivers/staging/prima/wlan.ko $KERNEL_DIR/build/modules/wlan2.ko
fi
cd $KERNEL_DIR/build/modules/
$STRIP --strip-unneeded *.ko
zimage=$KERNEL_DIR/arch/arm64/boot/Image
if ! [ -a $zimage ];
then
echo -e "$red << Failed to compile zImage, fix the errors first >>$white"
else
cd $KERNEL_DIR/build
rm *.zip > /dev/null 2>&1
echo -e "$yellow\n Build succesful, generating flashable zip now \n $white"
zip -r Radon-Kenzo-Mi-Mm.zip * > /dev/null
End=$(date +"%s")
Diff=$(($End - $Start))
echo -e "$yellow $KERNEL_DIR/build/Radon-Kenzo-Mi-Mm.zip \n$white"
echo -e "$gre << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds, variant($goodix$qc) >> \n $white"
fi
cd $KERNEL_DIR
if [ $goodix == 2 ]; then
git apply -R goodix.patch
fi
if [ $qc == 2 ]; then
git apply -R qc.patch
fi
