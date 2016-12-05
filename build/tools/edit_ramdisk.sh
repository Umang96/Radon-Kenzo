#!/sbin/sh

CONFIGFILE="/tmp/init.radon.rc"
echo "on boot" >> $CONFIGFILE
echo "" >> $CONFIGFILE
DT2W=$(cat /tmp/aroma/dt2w.prop | cut -d '=' -f2)
if [ $DT2W == 1 ]; then
DTP=1
elif [ $DT2W == 2 ]; then
DTP=0
fi 
echo "write /sys/android_touch/doubletap2wake " $DTP >> $CONFIGFILE
echo "" >> $CONFIGFILE
COLOR=$(cat /tmp/aroma/color.prop | cut -d '=' -f2)
if [ $COLOR == 1 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 275" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 249" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 264" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal 256 250 240" >> $CONFIGFILE
elif [ $COLOR == 2 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal 256 256 256" >> $CONFIGFILE
fi
echo "" >> $CONFIGFILE
INTERACTIVE=$(cat /tmp/aroma/interactive.prop | cut -d '=' -f2)

echo "on enable-low-power" >> $CONFIGFILE

echo "# Disable thermal & BCL core_control to update interactive gov settings" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/core_control/enabled 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode disable" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_mask 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_soc_mask 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode enable" >> $CONFIGFILE
echo "" >> $CONFIGFILE

if [ $INTERACTIVE == 1 ]; then
tld1="\"55 1017600:65 1190400:75 1305600:80 1382400:90 1401600:95"\"
tld2="\"75 1190400:85 1382400:90 1747200:95"\"
rate=30000
elif [ $INTERACTIVE == 2 ]; then
tld1="\"60 1017600:70 1190400:80 1305600:90 1382400:95 1401600:98"\"
tld2="\"70 1113600:80 1190400:90 1382400:95 1747200:98"\"
rate=40000
elif [ $INTERACTIVE == 3 ]; then
tld1="\"40 1017600:50 1190400:60 1305600:70 1382400:80 1401600:90"\"
tld2="\"60 1190400:70 1382400:80 1747200:90"\"
rate=20000
fi

echo "write /sys/devices/system/cpu/cpu0/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor interactive" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate $rate" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads $tld1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor interactive" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate $rate" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads $tld2" >>$CONFIGFILE
echo "" >> $CONFIGFILE
echo "# Disable thermal & BCL core_control to update interactive gov settings" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/core_control/enabled 1" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode disable" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_mask 48" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_soc_mask 48" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode enable" >> $CONFIGFILE
echo "" >> $CONFIGFILE
