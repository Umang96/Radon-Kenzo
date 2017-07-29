#!/sbin/sh
 #
 # Copyright © 2017, Umang Leekha "umang96" <umangleekha3@gmail.com> 
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
selinx=$(cat /tmp/aroma/sel.prop | cut -d '=' -f2)
qc=$(cat /tmp/aroma/crate.prop | cut -d '=' -f2)
pgt=$(cat /tmp/aroma/pgt.prop | cut -d '=' -f2)
zim=/tmp/Image1
if [ $qc -eq 1 ]; then
dim=/tmp/dt1.img
elif [ $qc -eq 2 ]; then
dim=/tmp/dt2.img
fi
cmd="androidboot.hardware=qcom ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 ramoops_memreserve=4M androidboot.selinux=enforcing"
if [ $selinx -eq 2 ]; then
cmd="androidboot.hardware=qcom ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 ramoops_memreserve=4M androidboot.selinux=permissive"
fi
pgtsuffix=" snd-soc-msm8x16-wcd.dig_core_collapse_enable=0"
if [ $pgt -eq 2 ]; then
cmd=$cmd$pgtsuffix
fi
cp /tmp/radon.sh /system/etc/radon.sh
chmod 644 /system/etc/radon.sh
cp /tmp/init.qcom.post_boot.sh /system/etc/init.qcom.post_boot.sh
cp /tmp/gxfingerprint.default.so /system/lib64/hw/gxfingerprint.default.so
chmod 644 /system/etc/init.qcom.post_boot.sh
cp -f /tmp/cpio /sbin/cpio
cd /tmp/
/sbin/busybox dd if=/dev/block/bootdevice/by-name/boot of=./boot.img
./unpackbootimg -i /tmp/boot.img
mkdir /tmp/ramdisk
cp /tmp/boot.img-ramdisk.gz /tmp/ramdisk/
cd /tmp/ramdisk/
gunzip -c /tmp/ramdisk/boot.img-ramdisk.gz | /tmp/cpio -i
rm /tmp/ramdisk/boot.img-ramdisk.gz
rm /tmp/boot.img-ramdisk.gz
cp /tmp/init.radon.rc /tmp/ramdisk/
chmod 0750 /tmp/ramdisk/init.radon.rc
if [ $(grep -c "import /init.radon.rc" /tmp/ramdisk/init.rc) == 0 ]; then
   sed -i "/import \/init\.\${ro.hardware}\.rc/aimport /init.radon.rc" /tmp/ramdisk/init.rc
fi
find . | cpio -o -H newc | gzip > /tmp/boot.img-ramdisk.gz
rm -r /tmp/ramdisk
cd /tmp/
./mkbootimg --kernel $zim --ramdisk /tmp/boot.img-ramdisk.gz --cmdline "$cmd"  --base 0x80000000 --pagesize 2048 --ramdisk_offset 0x01000000 --tags_offset 0x00000100 --dt $dim -o /tmp/newboot.img
/sbin/busybox dd if=/tmp/newboot.img of=/dev/block/bootdevice/by-name/boot
