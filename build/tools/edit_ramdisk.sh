#!/sbin/sh

CONFIGFILE="/tmp/init.radon.rc"
INTERACTIVE=$(cat /tmp/aroma/interactive.prop | cut -d '=' -f2)
if [ $INTERACTIVE == 1 ]; then
TLS="55 1017600:65 1190400:75 1305600:80 1382400:90 1401600:95"
TLB="75 1190400:85 1382400:90 1747200:95"
elif [ $INTERACTIVE == 2 ]; then
TLS="65 1017600:75 1190400:85 1305600:90 1382400:95 1401600:99"
TLB="75 1190400:85 1382400:90 1747200:99"
elif [ $INTERACTIVE == 3 ]; then
TLS="45 1017600:55 1190400:65 1305600:75 1382400:80 1401600:90"
TLB="65 1190400:75 1382400:80 1747200:95"
fi
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
echo "# DISABLE BCL & CORE CTL" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/core_control/enabled 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode disable" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_mask 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_soc_mask 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode disable" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# ENABLE A53 CLUSTER GOVERNOR" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor \"interactive\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads \"$TLS\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 400000" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# ENABLE A72 CLUSTER GOVERNOR" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor \"interactive\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads \"$TLB\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 400000" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# DT2W" >> $CONFIGFILE
echo "write /sys/android_touch/doubletap2wake " $DTP >> $CONFIGFILE
echo "write /sys/android_touch/vib_strength " $VIBS >> $CONFIGFILE
echo "" >> $CONFIGFILE
COLOR=$(cat /tmp/aroma/color.prop | cut -d '=' -f2)
echo "# KCAL" >> $CONFIGFILE
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
#echo "" >> $CONFIGFILE
#echo "# CHARGING RATE" >> $CONFIGFILE
#CRATE=$(cat /tmp/aroma/crate.prop | cut -d '=' -f2)
#if [ $CRATE == 5 ]; then
#CHG=2400
#elif [ $CRATE == 4 ]; then
#CHG=2200
#elif [ $CRATE == 3 ]; then
#CHG=2000
#elif [ $CRATE == 2 ]; then
#CHG=1800
#elif [ $CRATE == 1 ]; then
#CHG=1600
#fi 
#echo "write /sys/module/qpnp_smbcharger/parameters/default_dcp_icl_ma $CHG" >> $CONFIGFILE
#echo "write /sys/module/qpnp_smbcharger/parameters/default_hvdcp_icl_ma $CHG" >> $CONFIGFILE
HOTPLUG=$(cat /tmp/aroma/hotplug.prop | cut -d '=' -f2)
echo "# HOTPLUGGING" >> $CONFIGFILE
if [ $HOTPLUG == 1 ]; then
echo "write /sys/devices/system/cpu/cpu4/core_ctl/not_preferred \"1 0\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/max_cpus 2" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres 30" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres 25" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms 1600" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/task_thres 4" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/not_preferred \"1 0 0 0\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/min_cpus 2" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/max_cpus 4" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres 25" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres 20" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms 1800" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/is_big_cluster 0" >> $CONFIGFILE
elif [ $HOTPLUG == 2 ]; then
echo "write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/max_cpus 2" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres 0" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres 0" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms 1800" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/task_thres 4" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/min_cpus 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/max_cpus 4" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres 0" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres 0" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms 5000" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/is_big_cluster 0" >> $CONFIGFILE
fi
echo "chmod 0444 /sys/devices/system/cpu/cpu4/core_ctl/min_cpus" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "on enable-low-power" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# BRING CORES ONLINE" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu1/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu2/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu3/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu5/online 1" >> $CONFIGFILE
echo "" >> $CONFIGFILE
