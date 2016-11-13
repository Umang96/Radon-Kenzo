#!/sbin/sh
 #
 # Copyright � 2014, Varun Chitre "varun.chitre15" <varun.chitre15@gmail.com> 
 #
 # Live ramdisk patching script
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
 # Please maintain this if you use this script or any part of it
 #
goodix=$(cat /tmp/aroma/goodix.prop | cut -d '=' -f2)
overclock=$(cat /tmp/aroma/overclock.prop | cut -d '=' -f2)
if ([ $overclock -eq 1 ]&&[ $goodix -eq 1 ]); then
cmd="console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1"
dim=/tmp/dt11.img
zim=/tmp/Image1
elif ([ $overclock -eq 1 ]&&[ $goodix -eq 2 ]); then
cmd="console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 androidboot.selinux=permissive"
dim=/tmp/dt12.img
zim=/tmp/Image2
elif ([ $overclock -eq 2 ]&&[ $goodix -eq 1 ]); then
cmd="console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1"
dim=/tmp/dt21.img
zim=/tmp/Image1
elif ([ $overclock -eq 2 ]&&[ $goodix -eq 2 ]); then
cmd="console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 androidboot.selinux=permissive"
dim=/tmp/dt22.img
zim=/tmp/Image2
fi 
cd /tmp/
/sbin/busybox dd if=/dev/block/bootdevice/by-name/boot of=./boot.img
./unpackbootimg -i /tmp/boot.img
mkdir /tmp/ramdisk
cp /tmp/boot.img-ramdisk.gz /tmp/ramdisk/
cd /tmp/ramdisk/
gunzip -c /tmp/ramdisk/boot.img-ramdisk.gz | cpio -i
rm /tmp/ramdisk/boot.img-ramdisk.gz
rm /tmp/boot.img-ramdisk.gz
cp /tmp/init.radon.rc /tmp/ramdisk/
chmod 0750 /tmp/ramdisk/init.radon.rc
if [ $(grep -c "import /init.radon.rc" /tmp/ramdisk/init.rc) == 0 ]; then
   sed -i "/import \/init\.environ\.rc/aimport /init.radon.rc" /tmp/ramdisk/init.rc
fi
find . | cpio -o -H newc | gzip > /tmp/boot.img-ramdisk.gz
rm -r /tmp/ramdisk
cd /tmp/
./mkbootimg --kernel $zim --ramdisk /tmp/boot.img-ramdisk.gz --cmdline "$cmd"  --base 0x80000000 --pagesize 2048 --ramdisk_offset 0x02000000 --tags_offset 0x01e00000 --dt $dim -o /tmp/newboot.img
/sbin/busybox dd if=/tmp/newboot.img of=/dev/block/bootdevice/by-name/boot
