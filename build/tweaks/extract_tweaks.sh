#!/sbin/sh
 #
 # Copyright © 2016, Umang Leekha <umangleekha3@gmail.com> 
 #
 # Modules flashing script for radon
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
TWEAK=$(cat /tmp/aroma/interactive.prop | cut -d '=' -f2)
if [ $TWEAK == 1 ]; then
cp /tmp/init.qcom.post_boot_balance.sh /system/etc/init.qcom.post_boot.sh
elif [ $TWEAK == 2 ]; then
cp /tmp/init.qcom.post_boot_battery.sh /system/etc/init.qcom.post_boot.sh
elif [ $TWEAK == 3 ]; then
cp /tmp/init.qcom.post_boot_performance.sh /system/etc/init.qcom.post_boot.sh
fi
