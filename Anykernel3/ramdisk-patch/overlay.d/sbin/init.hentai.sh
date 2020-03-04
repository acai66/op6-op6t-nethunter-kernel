#!/system/bin/sh

#Tuna

sleep 30;


# Change Selinux status as per user desire
    setenforce 0

# Set TCP congestion algorithm
    echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control

# Enable fast charge as per user desire
    echo 1 > /sys/kernel/fast_charge/force_fast_charge

# Enable DT2W
    echo 1 > /proc/touchpanel/double_tap_enable
    
# Enable Gesture 
    echo 1 > /proc/touchpanel/letter_m_enable
    echo 1 > /proc/touchpanel/letter_s_enable
    echo 1 > /proc/touchpanel/letter_o_enable
    echo 1 > /proc/touchpanel/letter_w_enable
    
# Enable OTG by default
    echo 1 > /sys/class/power_supply/usb/otg_switch
    
# Enable adrenoboost
    echo 1 > /sys/class/devfreq/5000000.qcom,kgsl-3d0/adrenoboost

# Input boost and stune configuration
	echo "0:1056000 1:0 2:0 3:0 4:1056000 5:0 6:0 7:0" > /sys/module/cpu_boost/parameters/input_boost_freq
	echo 450 > /sys/module/cpu_boost/parameters/input_boost_ms
	echo 15 > /sys/module/cpu_boost/parameters/dynamic_stune_boost

# Set min cpu freq
    echo 825600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
    echo 1420800 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq

# Tweak IO performance after boot complete
    echo "bfq" > /sys/block/sda/queue/scheduler
    echo 128 > /sys/block/sda/queue/read_ahead_kb
