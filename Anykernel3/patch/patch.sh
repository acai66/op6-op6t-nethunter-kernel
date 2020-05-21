#!/system/bin/sh
sleep 3
mkdir -p /config/usb_gadget/g1/functions/hid.0
mkdir -p /config/usb_gadget/g1/functions/hid.1

mkdir -p /config/usb_gadget/g1/functions/acm.usb0
mkdir -p /config/usb_gadget/g1/functions/ecm.usb0
mkdir -p /config/usb_gadget/g1/functions/hid.0
echo "1" > /config/usb_gadget/g1/functions/hid.0/protocol
echo "1" > /config/usb_gadget/g1/functions/hid.0/subclass
echo "8" > /config/usb_gadget/g1/functions/hid.0/report_length
cp /keyboard-descriptor.bin /config/usb_gadget/g1/functions/hid.0/report_desc
mkdir -p /config/usb_gadget/g1/functions/hid.1
echo "1" > /config/usb_gadget/g1/functions/hid.1/protocol 
echo "2" > /config/usb_gadget/g1/functions/hid.1/subclass 
echo "4" > /config/usb_gadget/g1/functions/hid.1/report_length 
cp /mouse-descriptor.bin /config/usb_gadget/g1/functions/hid.1/report_desc

