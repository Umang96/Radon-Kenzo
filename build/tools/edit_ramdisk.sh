#!/sbin/sh

CONFIGFILE="/tmp/init.radon.rc"
echo "on boot" >> $CONFIGFILE
echo "" >> $CONFIGFILE
DT2W=$(cat /tmp/aroma/dt2w.prop | cut -d '=' -f2)
if [ $DT2W = 1 ]; then
DTP=1
elif [ $DT2W = 2 ]; then
DTP=0
fi 
echo "write /sys/android_touch/doubletap2wake " $DTP >> $CONFIGFILE
echo "" >> $CONFIGFILE
COLOR=$(cat /tmp/aroma/color.prop | cut -d '=' -f2)
if [ $COLOR = 1 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 270" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 257" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 265" >> $CONFIGFILE
elif [ $COLOR = 2 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 255" >> $CONFIGFILE
fi
echo "" >> $CONFIGFILE
