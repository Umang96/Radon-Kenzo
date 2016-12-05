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
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"256 250 240"\" >> $CONFIGFILE
elif [ $COLOR == 2 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"256 256 256"\" >> $CONFIGFILE
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
