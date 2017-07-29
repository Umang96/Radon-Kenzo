#!/system/bin/sh

################################################################################
# helper functions to allow Android init like script

function write() {
    echo -n $2 > $1
}

function copy() {
    cat $1 > $2
}

function get-set-forall() {
    for f in $1 ; do
        cat $f
        write $f $2
    done
}

################################################################################
    MemTotalStr=`cat /proc/meminfo | grep MemTotal`
    MemTotal=${MemTotalStr:16:8}

    # HMP scheduler (big.Little cluster related) settings
    write /proc/sys/kernel/sched_boost 0
    write /proc/sys/kernel/sched_upmigrate 95
    write /proc/sys/kernel/sched_downmigrate 85

    write /proc/sys/kernel/sched_window_stats_policy 2
    write /proc/sys/kernel/sched_ravg_hist_size 5

    write /sys/devices/system/cpu/cpu0/sched_mostly_idle_nr_run 3
    write /sys/devices/system/cpu/cpu1/sched_mostly_idle_nr_run 3
    write /sys/devices/system/cpu/cpu2/sched_mostly_idle_nr_run 3
    write /sys/devices/system/cpu/cpu3/sched_mostly_idle_nr_run 3
    write /sys/devices/system/cpu/cpu4/sched_mostly_idle_nr_run 3
    write /sys/devices/system/cpu/cpu5/sched_mostly_idle_nr_run 3

    write /sys/class/devfreq/mincpubw/governor "cpufreq"
    write /sys/class/devfreq/cpubw/governor "bw_hwmon"
    write /sys/class/devfreq/cpubw/bw_hwmon/io_percent 20
    write /sys/class/devfreq/cpubw/bw_hwmon/guard_band_mbps 30

    # Disable thermal
    write /sys/module/msm_thermal/core_control/enabled 0

    # disable thermal bcl hotplug to switch governor
    write /sys/devices/soc.0/qcom,bcl.56/mode "disable"
    write /sys/devices/soc.0/qcom,bcl.56/hotplug_mask 0
    write /sys/devices/soc.0/qcom,bcl.56/hotplug_soc_mask 0
    write /sys/devices/soc.0/qcom,bcl.56/mode "disable"

    # HMP Task packing settings for 8956
    write /proc/sys/kernel/sched_small_task 30
    write /sys/devices/system/cpu/cpu0/sched_mostly_idle_load 20
    write /sys/devices/system/cpu/cpu1/sched_mostly_idle_load 20
    write /sys/devices/system/cpu/cpu2/sched_mostly_idle_load 20
    write /sys/devices/system/cpu/cpu3/sched_mostly_idle_load 20
    write /sys/devices/system/cpu/cpu4/sched_mostly_idle_load 20
    write /sys/devices/system/cpu/cpu5/sched_mostly_idle_load 20

    write /proc/sys/kernel/sched_boost 0

    # Bring up all cores online
    write /sys/devices/system/cpu/cpu1/online 1
    write /sys/devices/system/cpu/cpu2/online 1
    write /sys/devices/system/cpu/cpu3/online 1
    write /sys/devices/system/cpu/cpu4/online 1
    write /sys/devices/system/cpu/cpu5/online 1

    # Enable LPM Prediction
    write /sys/module/lpm_levels/parameters/lpm_prediction 1

    # Enable Low power modes
    write /sys/module/lpm_levels/parameters/sleep_disabled 0

    # Disable L2 GDHS on 8976
    write /sys/module/lpm_levels/system/a53/a53-l2-gdhs/idle_enabled "N"
    write /sys/module/lpm_levels/system/a72/a72-l2-gdhs/idle_enabled "N"

    # Re-enable BCL hotplug
    write /sys/devices/soc.0/qcom,bcl.56/mode "disable"
    write /sys/devices/soc.0/qcom,bcl.56/hotplug_mask 48
    write /sys/devices/soc.0/qcom,bcl.56/hotplug_soc_mask 48
    write /sys/devices/soc.0/qcom,bcl.56/mode "disable"

    # Enable timer migration to little cluster
    write /proc/sys/kernel/power_aware_timer_migration 1

    # Enable sched colocation and colocation inheritance
    write /proc/sys/kernel/sched_grp_upmigrate 130
    write /proc/sys/kernel/sched_grp_downmigrate 110
    write /proc/sys/kernel/sched_enable_thread_grouping 1

    # set (super) packing parameters
    write /sys/devices/system/cpu/cpu0/sched_mostly_idle_freq 1017600
    write /sys/devices/system/cpu/cpu4/sched_mostly_idle_freq 0

    # Read adj series and set adj threshold for PPR and ALMK.
    # This is required since adj values change from framework to framework.
    adj_series=`cat /sys/module/lowmemorykiller/parameters/adj`
    adj_1="${adj_series#*,}"
    set_almk_ppr_adj="${adj_1%%,*}"

    # PPR and ALMK should not act on HOME adj and below.
    # Normalized ADJ for HOME is 6. Hence multiply by 6
    # ADJ score represented as INT in LMK params, actual score can be in decimal
    # Hence add 6 considering a worst case of 0.9 conversion to INT (0.9*6).
    set_almk_ppr_adj=$(((set_almk_ppr_adj * 6) + 6))
    echo $set_almk_ppr_adj > /sys/module/lowmemorykiller/parameters/adj_max_shift
    echo $set_almk_ppr_adj > /sys/module/process_reclaim/parameters/min_score_adj

    #Set Low memory killer minfree parameters
    # 64 bit up to 2GB with use 14K, and above 2GB will use 18K
    #
    # Set ALMK parameters (usually above the highest minfree values)
    # 64 bit will have 81K 
    chmod 0660 /sys/module/lowmemorykiller/parameters/minfree

    if [ $MemTotal -gt 2000000 ]; then
        echo 0 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
        echo 10 > /sys/module/process_reclaim/parameters/pressure_min
        echo 1024 > /sys/module/process_reclaim/parameters/per_swap_size
        echo "18432,23040,27648,32256,55296,80640" > /sys/module/lowmemorykiller/parameters/minfree
        echo 81250 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
    else
        echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
        echo 10 > /sys/module/process_reclaim/parameters/pressure_min
        echo 1024 > /sys/module/process_reclaim/parameters/per_swap_size
        echo "14746,18432,22118,25805,40000,55000" > /sys/module/lowmemorykiller/parameters/minfree
        echo 81250 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min 
    fi

    # Set scheduler
    write /sys/block/mmcblk0/queue/scheduler fiops
