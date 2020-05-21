# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Acai_Nethunter
do.devicecheck=1
do.modules=1
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=OnePlus6
device.name2=enchilada
device.name3=OnePlus6T
device.name4=fajita
device.name5=oneplus6
device.name6=oneplus6t
supported.versions=10
supported.patchlevels=
'; } # end properties

# shell variables
block=boot;
is_slot_device=1;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## NetHunter additions

mount -o rw,remount -t auto /system;
test -e /dev/block/bootdevice/by-name/system || local slot=$(getprop ro.boot.slot_suffix 2>/dev/null);
ui_print $slot
mount -o rw,remount -t auto /dev/block/bootdevice/by-name/system$slot /system_root;
ui_print "patching";
mkdir -p /data/adb/service.d/;
rm -rf /data/adb/service.d/patch.sh;
cp $home/patch/patch.sh /data/adb/service.d/;
chmod 0755 /data/adb/service.d/patch.sh;
SYSTEM="/system";
SYSTEM_ROOT="/system_root";

# debug
#touch "$SYSTEM_ROOT/system_root.acai"
#touch "$SYSTEM/system.acai"
#echo "system:" >> /tmp/acai.log;
#ls $SYSTEM >> /tmp/acai.log;
#echo "system_root:" >> /tmp/acai.log;
#ls $SYSTEM_ROOT >> /tmp/acai.log;


setperm() {
	find "$3" -type d -exec chmod "$1" {} \;
	find "$3" -type f -exec chmod "$2" {} \;
}

install() {
	setperm "$2" "$3" "$home$1";
	if [ "$4" ]; then
	    # ui_print "$home$1  to  $(dirname "$4")/"
		cp -r "$home$1" "$(dirname "$4")/";
		return;
	fi;
	cp -r "$home$1" "$(dirname "$1")/";
}

[ -d $home/system/etc/firmware ] && {
	install "/system/etc/firmware" 0755 0644 "$SYSTEM/etc/firmware";
}

[ -d $home/system/etc/init.d ] && {
	install "/system/etc/init.d" 0755 0755 "$SYSTEM/etc/init.d";
}

[ -d $home/system/lib ] && {
	install "/system/lib" 0755 0644 "$SYSTEM/lib";
}

[ -d $home/system/lib64 ] && {
	install "/system/lib64" 0755 0644 "$SYSTEM/lib64";
}

[ -d $home/system/bin ] && {
	install "/system/bin" 0755 0755 "$SYSTEM/bin";
}

[ -d $home/system/xbin ] && {
    ui_print "installing xbin"
	install "/system/xbin" 0755 0755 "$SYSTEM/xbin";
}

[ -d $home/data/local ] && {
	install "/data/local" 0755 0644;
}

[ -d $home/ramdisk-patch ] && {
    ui_print "patching ramdisk"
	setperm "0755" "0750" "$home/ramdisk-patch";
        chown root:shell $home/ramdisk-patch/*;
    # ui_print "$home/ramdisk-patch/  to  $SYSTEM_ROOT/"
	cp -r $home/ramdisk-patch/* "$SYSTEM_ROOT/";
}

#if [ ! "$(grep /init.nethunter.rc $SYSTEM_ROOT/init.rc)" ]; then
#  insert_after_last "$SYSTEM_ROOT/init.rc" "import .*\.rc" "import /init.nethunter.rc";
#fi;
insert_line $SYSTEM_ROOT/init.rc "import /init.nethunter.rc" after "import .*\.rc" "import /init.nethunter.rc";

#if [ ! "$(grep /dev/hidg* $SYSTEM_ROOT/ueventd.rc)" ]; then
#  insert_after_last "$SYSTEM_ROOT/ueventd.rc" "/dev/kgsl.*root.*root" "# HID driver\n/dev/hidg* 0666 root root";
#fi;
insert_line $SYSTEM_ROOT/ueventd.rc "/dev/hidg" after "/dev/vndbinder.*root.*root" "# HID driver\n/dev/hidg* 0666 root root";


mount -o ro,remount -t auto /system;
## End NetHunter additions


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;



## AnyKernel install
dump_boot;

# begin ramdisk changes

if [ -d $ramdisk/.backup ]; then
  patch_cmdline "skip_override" "skip_override";
else
  patch_cmdline "skip_override" "";
fi;


# end ramdisk changes

write_boot;
## end install

