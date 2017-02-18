#!/sbin/sh

CONFIGFILE="/tmp/init.radon.rc"
INTERACTIVE=$(cat /tmp/aroma/interactive.prop | cut -d '=' -f2)
if [ $INTERACTIVE == 1 ]; then
TLS="50 1190400:70 1382400:90 1401600:95"
TLB="75 1190400:85 1382400:90 1747200:95"
FMS=691200
FMB=883200
TR=20000
UTS=30
DTS=25
UTB=35
DTB=30
AID=N
DFS=1
elif [ $INTERACTIVE == 2 ]; then
TLS="75 1190400:85 1382400:95 1401600:99"
TLB="75 1190400:85 1382400:90 1747200:99"
FMS=400000
FMB=400000
TR=30000
UTS=40
DTS=35
UTB=45
DTB=40
AID=Y
DFS=0
elif [ $INTERACTIVE == 3 ]; then
TLS="40 1190400:60 1382400:80 1401600:85"
TLB="65 1190400:75 1382400:80 1747200:95"
FMS=691200
FMB=883200
TR=20000
UTS=25
DTS=20
UTB=35
DTB=30
AID=N
DFS=1
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
echo "# SWAPPINESS" >> $CONFIGFILE
echo "write /proc/sys/vm/swappiness 20" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# DT2W" >> $CONFIGFILE
echo "write /sys/android_touch/doubletap2wake " $DTP >> $CONFIGFILE
echo "write /sys/android_touch/vib_strength " $VIBS >> $CONFIGFILE
echo "" >> $CONFIGFILE
COLOR=$(cat /tmp/aroma/color.prop | cut -d '=' -f2)
echo "# KCAL" >> $CONFIGFILE
if [ $COLOR == 1 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 271" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 256" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"254 252 230"\" >> $CONFIGFILE
elif [ $COLOR == 2 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"256 256 256"\" >> $CONFIGFILE
fi
echo "" >> $CONFIGFILE
echo "# CHARGING RATE" >> $CONFIGFILE
CRATE=$(cat /tmp/aroma/crate.prop | cut -d '=' -f2)
if [ $CRATE == 1 ]; then
CHG=2000
elif [ $CRATE == 2 ]; then
CHG=2400
fi 
echo "chmod 666 /sys/module/qpnp_smbcharger/parameters/default_dcp_icl_ma" >> $CONFIGFILE
echo "chmod 666 /sys/module/qpnp_smbcharger/parameters/default_hvdcp_icl_ma" >> $CONFIGFILE
echo "write /sys/module/qpnp_smbcharger/parameters/default_dcp_icl_ma $CHG" >> $CONFIGFILE
echo "write /sys/module/qpnp_smbcharger/parameters/default_hvdcp_icl_ma $CHG" >> $CONFIGFILE
HOTPLUG=$(cat /tmp/aroma/hotplug.prop | cut -d '=' -f2)
echo "" >> $CONFIGFILE
echo "on enable-low-power" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# DISABLE BCL & CORE CTL" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/core_control/enabled 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode disable" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_mask 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_soc_mask 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode disable" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# BRING CORES ONLINE" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu1/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu2/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu3/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu5/online 1" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# HOTPLUGGING" >> $CONFIGFILE
if [ $HOTPLUG == 1 ]; then
echo "write /sys/devices/system/cpu/cpu4/core_ctl/not_preferred \"1 0\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/max_cpus 2" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres $UTB" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres $DTB" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms 1000" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/task_thres 4" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/not_preferred \"1 0 0 0\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/min_cpus 2" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/max_cpus 4" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres $UTS" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres $DTS" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms 1000" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/is_big_cluster 0" >> $CONFIGFILE
elif [ $HOTPLUG == 2 ]; then
echo "write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 0" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/max_cpus 2" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres 0" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres 0" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/task_thres 4" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/min_cpus 0" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/max_cpus 4" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres 0" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres 0" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/core_ctl/is_big_cluster 0" >> $CONFIGFILE
fi
echo "" >> $CONFIGFILE
echo "# DISABLE BCL & CORE CTL" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/core_control/enabled 1" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode disable" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_mask 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_soc_mask 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode disable" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# TWEAK A53 CLUSTER GOVERNOR" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate $TR" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads \"$TLS\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq $FMS" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# TWEAK A72 CLUSTER GOVERNOR" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate $TR" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads \"$TLB\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq $FMB" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "on property:dev.bootcomplete=1" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# SET IO SCHEDULER" >> $CONFIGFILE
echo "setprop sys.io.scheduler \"fiops\"" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# ADRENO IDLER" >> $CONFIGFILE
echo "write /sys/module/adreno_idler/parameters/adreno_idler_active $AID" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# DYNAMIC FSYNC" >> $CONFIGFILE
echo "write /sys/kernel/dyn_fsync/Dyn_fsync_active $DFS" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# VIBRATOR STRENGTH" >> $CONFIGFILE
echo "write /sys/class/timed_output/vibrator/vtg_level 2313" >> $CONFIGFILE
