#!/sbin/sh

CONFIGFILE="/tmp/init.radon.rc"
echo "on boot" >> $CONFIGFILE
echo "" >> $CONFIGFILE
DT2W=$(cat /tmp/aroma/dt2w.prop | cut -d '=' -f2)
if [ $DT2W == 1 ]; then
DTP=1
VIBS=75
elif [ $DT2W == 2 ]; then
DTP=1
VIBS=0
elif [ $DT2W == 3 ]; then
DTP=0
VIBS=75
fi 
echo "write /sys/android_touch/doubletap2wake " $DTP >> $CONFIGFILE
echo "write /sys/android_touch/vib_strength " $VIBS >> $CONFIGFILE
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
CRATE=$(cat /tmp/aroma/crate.prop | cut -d '=' -f2)
if [ $CRATE == 5 ]; then
CHG=2400
elif [ $CRATE == 4 ]; then
CHG=2200
elif [ $CRATE == 3 ]; then
CHG=2000
elif [ $CRATE == 2 ]; then
CHG=1800
elif [ $CRATE == 1 ]; then
CHG=1600
fi 
echo "write /sys/module/qpnp_smbcharger/parameters/default_dcp_icl_ma $CHG" >> $CONFIGFILE
echo "write /sys/module/qpnp_smbcharger/parameters/default_hvdcp_icl_ma $CHG" >> $CONFIGFILE
HOTPLUG=$(cat /tmp/aroma/hotplug.prop | cut -d '=' -f2)
echo "" >> $CONFIGFILE
echo "# Disable thermal & BCL core_control to update interactive gov settings" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/core_control/enabled 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode disable" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_mask 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_soc_mask 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode disable" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# Enable hotplug" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/min_cpus 4" >> $CONFIGFILE
if [ $HOTPLUG == 1 ]; then
echo "write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 0" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/max_cpus 2" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres 25" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres 20" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms 1800" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster 1" >> $CONFIGFILE
elif [ $HOTPLUG == 2 ]; then
echo "write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 2" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/max_cpus 2" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres 0" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms 1800" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster 1" >> $CONFIGFILE
fi
echo "on enable-low-power" >> $CONFIGFILE
echo "# Disable thermal & BCL core_control to update interactive gov settings" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/core_control/enabled 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode disable" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_mask 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_soc_mask 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode disable" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu1/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu2/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu3/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu5/online 1" >> $CONFIGFILE
