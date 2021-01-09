#!/vendor/bin/sh

scriptName=$0

# Read the Board/Platform name
hardwareName=$(getprop ro.hardware)

/vendor/bin/log -t "$scriptName" -p i "*** STARTING LKM LOADER SR FOR ***:" $hardwareName

do_insmod()
{
if [ -e "$1" ]; then
        insmod $@ > /dev/kmsg 2>&1
fi
}

#====================================================================================
# Early load is for loading modules "on fs"
early_load()
{
# list of Vendor modules
# insmod /vendor/lib/modules/example1.ko
/vendor/bin/log -t "$scriptName" -p i "Early Loading SR modules started"

# load COMMS drivers
do_insmod /vendor/lib/modules/bluedroid_pm.ko
if [ "`cat /proc/device-tree/brcmfmac_pcie_wlan_upstream/status`" = "okay" ]; then
        /vendor/bin/log -t "wifiloader" -p i " Loading upstream brcmfmac driver for wlan"
        do_insmod /vendor/lib/modules/cypress-fmac-upstream/compat.ko
        do_insmod /vendor/lib/modules/cypress-fmac-upstream/cfg80211.ko
        do_insmod /vendor/lib/modules/cypress-fmac-upstream/brcmutil.ko
        do_insmod /vendor/lib/modules/cypress-fmac-upstream/brcmfmac.ko
fi

/vendor/bin/log -t "$scriptName" -p i "Early Loading LKM SR modules completed"

# Joycons (make sure to load after pwm_fan to avoid excessive fanspin!)
/vendor/bin/log -t "$scriptName" -p i "Loading JoyCon serdev modules started"

do_insmod /vendor/lib/modules/crc8.ko
do_insmod /vendor/lib/modules/joycon-serdev.ko

/vendor/bin/log -t "$scriptName" -p i "Loading JoyCon serdev modules completed"

}

#===================================================================================

# Normal load is for loading on boot
normal_load()
{
/vendor/bin/log -t "$scriptName" -p i "No LKM modules to load for SR"
}

#--------------------------------------------------------------------------------

if [ "$1" = "early" ]; then
    early_load
else
    normal_load
fi

