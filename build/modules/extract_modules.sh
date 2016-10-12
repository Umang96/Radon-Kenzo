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
cp /tmp/wlan.ko /system/lib/modules/wlan.ko
cp /tmp/wlan.ko /system/lib/modules/pronto/pronto_wlan.ko
